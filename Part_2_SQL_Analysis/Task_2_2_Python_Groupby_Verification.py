import pandas as pd

# Put appointments_clean.csv in the same folder as this script.
df = pd.read_csv("appointments_clean.csv")

# Reproduce the clinic appointment and no-show counts using pandas groupby.
clinic_check = (
    df.groupby("clinic_id")
      .agg(
          appointments=("appointment_id", "count"),
          no_shows=("no_show", "sum")
      )
      .reset_index()
)

clinic_check["no_show_pct"] = (
    100 * clinic_check["no_shows"] / clinic_check["appointments"]
).round(1)

print("Python clinic groupby verification:")
print(clinic_check.sort_values("no_show_pct", ascending=False).to_string(index=False))

print("\nOverall verification:")
print("Clinics:", df["clinic_id"].nunique())
print("Appointments:", len(df))
print("No-shows:", int(df["no_show"].sum()))
print("Overall no-show rate:", round(100 * df["no_show"].mean(), 2), "%")

assert len(df) == 990
assert int(df["no_show"].sum()) == 218
assert df["clinic_id"].nunique() == 8
assert int(clinic_check["appointments"].sum()) == 990
assert int(clinic_check["no_shows"].sum()) == 218

print("\nPASS: Python totals reconcile with the Task 2.1 database totals.")
