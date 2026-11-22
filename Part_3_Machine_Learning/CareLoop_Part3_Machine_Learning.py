# CareLoop Clinics — Part 3: Machine Learning
# Run this notebook/script in Google Colab with appointments_clean.csv uploaded.
# The test set is held out for final reporting only. Do not tune on it.

!pip -q install scikit-learn pandas numpy

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, GridSearchCV, cross_val_score, cross_val_predict
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.pipeline import Pipeline
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, roc_auc_score, confusion_matrix

# 1. Load data
df = pd.read_csv("appointments_clean.csv")
print("Dataset shape:", df.shape)

# 2. Build exactly the allowed features (do not include IDs, dates, clinic_id, gender or status)
X = df[["age", "distance_km", "fee_inr", "lead_days", "prior_no_shows",
        "reminder_sent", "booking_channel", "visit_type"]].copy()
X["reminder_sent"] = X["reminder_sent"].map({"Yes": 1, "No": 0})
X = pd.get_dummies(X, columns=["booking_channel", "visit_type"])
y = df["no_show"].astype(int)

# Keep appointment IDs aside for the final risk-score file only
appointment_ids = df["appointment_id"].copy()

# 3. Split once. Do not shuffle/re-sort the source rows before this step.
X_train, X_test, y_train, y_test, id_train, id_test = train_test_split(
    X, y, appointment_ids, test_size=0.2, random_state=42
)
print("Feature columns:", X.shape[1])
print("Training rows:", len(X_train))
print("Test rows:", len(X_test))
print("No-shows in test:", int(y_test.sum()))
print("Baseline accuracy (always predict Attended):", round((y_test == 0).mean(), 4))

def report_metrics(name, model, X_eval, y_eval, threshold=0.5, scaled=False):
    probabilities = model.predict_proba(X_eval)[:, 1]
    predictions = (probabilities >= threshold).astype(int)
    return {
        "model": name,
        "accuracy": accuracy_score(y_eval, predictions),
        "precision": precision_score(y_eval, predictions, zero_division=0),
        "recall": recall_score(y_eval, predictions, zero_division=0),
        "F1": f1_score(y_eval, predictions, zero_division=0),
        "ROC_AUC": roc_auc_score(y_eval, probabilities),
        "confusion_matrix": confusion_matrix(y_eval, predictions).tolist()
    }

# 4. Logistic regression: fit scaler on training data only
scaler = StandardScaler()
X_train_s = scaler.fit_transform(X_train)
X_test_s = scaler.transform(X_test)
logistic = LogisticRegression(max_iter=1000)
logistic.fit(X_train_s, y_train)
logistic_test = report_metrics("Logistic regression", logistic, X_test_s, y_test)
print("\\nLogistic regression test metrics:", logistic_test)

# Coefficients in feature order; standardised-feature interpretation
coef_table = pd.DataFrame({
    "feature": X.columns,
    "coefficient": logistic.coef_[0],
    "odds_ratio_per_1_SD": np.exp(logistic.coef_[0] / scaler.scale_)
}).sort_values("coefficient", ascending=False)
print("\\nLogistic coefficients:")
display(coef_table)

# 5. Decision trees: full depth and depth 3
tree_full = DecisionTreeClassifier(random_state=42)
tree_full.fit(X_train, y_train)
tree3 = DecisionTreeClassifier(random_state=42, max_depth=3)
tree3.fit(X_train, y_train)

def tree_summary(name, model):
    return {
        "model": name,
        "training_accuracy": accuracy_score(y_train, model.predict(X_train)),
        "test_accuracy": accuracy_score(y_test, model.predict(X_test)),
        "tree_depth": model.get_depth()
    }

print("\\nDecision tree comparison:")
display(pd.DataFrame([
    tree_summary("Full-depth tree", tree_full),
    tree_summary("Depth-3 tree", tree3)
]))
print("Depth-3 test metrics:", report_metrics("Depth-3 tree", tree3, X_test, y_test))

# 6. Random forest
forest = RandomForestClassifier(n_estimators=100, random_state=42)
forest.fit(X_train, y_train)
forest_test = report_metrics("Random forest", forest, X_test, y_test)
print("\\nRandom forest test metrics:", forest_test)

importance = pd.DataFrame({
    "feature": X.columns,
    "importance": forest.feature_importances_
}).sort_values("importance", ascending=False)
print("\\nTop three random-forest feature importances:")
display(importance.head(3))

# 7. Grid search on TRAINING SET ONLY
grid = GridSearchCV(
    RandomForestClassifier(random_state=42),
    {"n_estimators": [100, 200], "max_depth": [3, 5, 8]},
    cv=5, scoring="roc_auc"
)
grid.fit(X_train, y_train)
print("Best random-forest parameters:", grid.best_params_)
print("Best cross-validated ROC-AUC:", round(grid.best_score_, 4))

# 8. Compare 5-fold CV ROC-AUC on training data.
# Pipeline ensures the scaler is refit inside every fold.
lr_pipeline = Pipeline([
    ("scaler", StandardScaler()),
    ("model", LogisticRegression(max_iter=1000))
])
lr_cv = cross_val_score(lr_pipeline, X_train, y_train, cv=5, scoring="roc_auc").mean()
tree3_cv = cross_val_score(
    DecisionTreeClassifier(random_state=42, max_depth=3),
    X_train, y_train, cv=5, scoring="roc_auc"
).mean()
forest_cv = cross_val_score(
    RandomForestClassifier(n_estimators=100, random_state=42),
    X_train, y_train, cv=5, scoring="roc_auc"
).mean()
tuned_forest_cv = grid.best_score_

cv_table = pd.DataFrame([
    ["Logistic regression", lr_cv],
    ["Depth-3 decision tree", tree3_cv],
    ["Random forest (100 trees)", forest_cv],
    ["Tuned random forest", tuned_forest_cv]
], columns=["model", "training_5fold_CV_ROC_AUC"])
print("\\nTraining-only cross-validation comparison:")
display(cv_table)

# 9. Choose model and threshold using TRAINING-SET out-of-fold probabilities only.
# Based on the supplied course reference, logistic regression is the expected winner.
oof_probabilities = cross_val_predict(
    lr_pipeline, X_train, y_train, cv=5, method="predict_proba"
)[:, 1]

threshold_rows = []
for threshold in [0.50, 0.35]:
    oof_pred = (oof_probabilities >= threshold).astype(int)
    threshold_rows.append({
        "threshold": threshold,
        "precision": precision_score(y_train, oof_pred, zero_division=0),
        "recall": recall_score(y_train, oof_pred, zero_division=0),
        "F1": f1_score(y_train, oof_pred, zero_division=0),
        "number_flagged": int(oof_pred.sum())
    })
threshold_table = pd.DataFrame(threshold_rows)
print("\\nTraining out-of-fold threshold comparison:")
display(threshold_table)

chosen_model_name = "Logistic regression"
chosen_threshold = 0.35
print("Chosen model:", chosen_model_name)
print("Chosen threshold:", chosen_threshold)
print("Reason: highest F1 among the compared thresholds, with materially higher recall.")

# 10. Final fit on all training rows, then evaluate the test set ONCE.
# The test set was not used for model or threshold selection.
lr_pipeline.fit(X_train, y_train)
test_probabilities = lr_pipeline.predict_proba(X_test)[:, 1]
test_predictions = (test_probabilities >= chosen_threshold).astype(int)

final_test_metrics = {
    "accuracy": accuracy_score(y_test, test_predictions),
    "precision": precision_score(y_test, test_predictions, zero_division=0),
    "recall": recall_score(y_test, test_predictions, zero_division=0),
    "F1": f1_score(y_test, test_predictions, zero_division=0),
    "ROC_AUC": roc_auc_score(y_test, test_probabilities),
    "confusion_matrix": confusion_matrix(y_test, test_predictions).tolist(),
    "number_flagged": int(test_predictions.sum())
}
print("\\nFINAL TEST-SET RESULTS (reporting only):")
print(final_test_metrics)

# 11. Required output: one row for every test-set appointment.
test_risk_scores = pd.DataFrame({
    "appointment_id": id_test.values,
    "no_show": y_test.values,
    "risk_prob": test_probabilities,
    "flag": (test_probabilities >= chosen_threshold).astype(int)
})
test_risk_scores.to_csv("test_risk_scores.csv", index=False)
print("\\nSaved test_risk_scores.csv with", len(test_risk_scores), "test rows.")
display(test_risk_scores.head(10))

# Optional: save supporting comparison tables for the project repository.
cv_table.to_csv("part3_cv_comparison.csv", index=False)
threshold_table.to_csv("part3_threshold_comparison.csv", index=False)
coef_table.to_csv("part3_logistic_coefficients.csv", index=False)
importance.to_csv("part3_random_forest_importance.csv", index=False)
