# ============================================================
#        EMERGENCY PATIENT PRIORITY SYSTEM
# ============================================================

# File where patient data will be saved
FILE_NAME = "patients.txt"


# ============================================================
# FUNCTION 1: CALCULATE PATIENT PRIORITY
# ============================================================

def calculate_priority(heart_rate, spo2, temperature, systolic_bp):

    score = 0

    # Heart rate
    if heart_rate < 50 or heart_rate > 120:
        score += 2
    elif heart_rate < 60 or heart_rate > 100:
        score += 1

    # SpO2
    if spo2 < 90:
        score += 3
    elif spo2 < 94:
        score += 2
    elif spo2 < 96:
        score += 1

    # Temperature
    if temperature >= 39 or temperature < 35:
        score += 2
    elif temperature >= 38:
        score += 1

    # Blood pressure
    if systolic_bp < 90 or systolic_bp > 180:
        score += 2
    elif systolic_bp < 100 or systolic_bp > 160:
        score += 1

    # Decide priority
    if score >= 6:
        return "CRITICAL"
    elif score >= 3:
        return "URGENT"
    else:
        return "NORMAL"


# ============================================================
# FUNCTION 2: SAVE PATIENTS TO FILE
# ============================================================

def save_patients():

    file = open(FILE_NAME, "w")

    for patient in patients:

        file.write(
            str(patient["id"]) + "|" +
            patient["name"] + "|" +
            str(patient["age"]) + "|" +
            patient["gender"] + "|" +
            str(patient["heart_rate"]) + "|" +
            str(patient["spo2"]) + "|" +
            str(patient["temperature"]) + "|" +
            str(patient["systolic_bp"]) + "|" +
            patient["priority"] + "\n"



    file.close()

# ============================================================
# FUNCTION 3: LOAD PATIENTS FROM FILE
# ============================================================

def load_patients():

loaded_patients = []

try:
        file = open(FILE_NAME, "r")

        for line in file:

            line = line.strip()

            if line != "":
                data = line.split("|")

                patient = {
                    "id": int(data[0]),
                    "name": data[1],
                    "age": int(data[2]),
                    "gender": data[3],
                    "heart_rate": int(data[4]),
                    "spo2": int(data[5]),
                    "temperature": float(data[6]),
                    "systolic_bp": int(data[7]),
                    "priority": data[8]
                }

                loaded_patients.append(patient)

        file.close()

        except FileNotFoundError:
        # If file doesn't exist, start with empty list
        pass

    return loaded_patients


    # ============================================================
# FUNCTION 4: GENERATE PATIENT ID
# ============================================================

def generate_id():

    if len(patients) == 0:
        return 1

    highest_id = 0

    for patient in patients:

        if patient["id"] > highest_id:
            highest_id = patient["id"]

    return highest_id + 1


# ============================================================
# FUNCTION 5: ADD PATIENT
# ============================================================

def add_patient():

    print("\n--------------------------------")
    print("        ADD NEW PATIENT")
    print("--------------------------------")

    name = input("Enter patient name: ")

    age = int(input("Enter age: "))

    gender = input("Enter gender: ")

    print("\nEnter patient vitals:")

    heart_rate = int(input("Heart rate (bpm): "))

    spo2 = int(input("SpO2 (%): "))

    temperature = float(input("Temperature (°C): "))

    systolic_bp = int(input("Systolic blood pressure: "))

    priority = calculate_priority(
        heart_rate,
        spo2,
        temperature,
        systolic_bp
    )

patient = {
        "id": generate_id(),
        "name": name,
        "age": age,
        "gender": gender,
        "heart_rate": heart_rate,
        "spo2": spo2,
        "temperature": temperature,
        "systolic_bp": systolic_bp,
        "priority": priority
    }

    patients.append(patient)

    # Save immediately
    save_patients()

    print("\nPatient added successfully!")
    print("Patient ID:", patient["id"])
    print("Priority:", patient["priority"])


# ============================================================
# FUNCTION 6: DISPLAY ONE PATIENT
# ============================================================

def display_patient(patient):

    print("\n--------------------------------")
    print("Patient ID:", patient["id"])
    print("Name:", patient["name"])
    print("Age:", patient["age"])
    print("Gender:", patient["gender"])
    print("Heart Rate:", patient["heart_rate"], "bpm")
    print("SpO2:", patient["spo2"], "%")
    print("Temperature:", patient["temperature"], "°C")
    print("Systolic BP:", patient["systolic_bp"])
    print("Priority:", patient["priority"])
    print("--------------------------------")


# ============================================================
# FUNCTION 7: SHOW ALL PATIENTS
# ============================================================

def show_all_patients():

    print("\n================================")
    print("        ALL PATIENTS")
    print("================================")

    if len(patients) == 0:
        print("No patients found.")
        return

    # Show critical patients first
    priority_order = {
        "CRITICAL": 1,
        "URGENT": 2,
        "NORMAL": 3
    }

    sorted_patients = sorted(
        patients,
        key=lambda x: priority_order[x["priority"]]
    )

    for patient in sorted_patients:
        display_patient(patient)


# ============================================================
# FUNCTION 8: SEARCH PATIENT
# ============================================================

def search_patient():

    print("\n--------------------------------")
    print("        SEARCH PATIENT")
    print("--------------------------------")

    patient_id = int(input("Enter patient ID: "))

    found = False

    for patient in patients:

        if patient["id"] == patient_id:

            display_patient(patient)

            found = True
            break

    if found == False:
        print("Patient not found.")


# ============================================================
# FUNCTION 9: UPDATE PATIENT
# ============================================================

def update_patient():

    print("\n--------------------------------")
    print("        UPDATE PATIENT")
    print("--------------------------------")

    patient_id = int(input("Enter patient ID: "))

    for patient in patients:

        if patient["id"] == patient_id:

            print("\nCurrent patient details:")
            display_patient(patient)

            print("\nEnter new information:")

            patient["name"] = input("Enter new name: ")

            patient["age"] = int(input("Enter new age: "))

            patient["gender"] = input("Enter new gender: ")

            print("\nEnter new vitals:")

            patient["heart_rate"] = int(
                input("Heart rate (bpm): ")
            )

patient["spo2"] = int(
                input("SpO2 (%): ")
            )

            patient["temperature"] = float(
                input("Temperature (°C): ")
            )

            patient["systolic_bp"] = int(
                input("Systolic blood pressure: ")
            )

            # Recalculate priority
            patient["priority"] = calculate_priority(
                patient["heart_rate"],
                patient["spo2"],
                patient["temperature"],
                patient["systolic_bp"]
            )

            save_patients()

            print("\nPatient updated successfully!")
            print("New priority:", patient["priority"])

            return

    print("Patient not found.")


# ============================================================
# FUNCTION 10: DELETE PATIENT
# ============================================================

def delete_patient():

    print("\n--------------------------------")
    print("        DELETE PATIENT")
    print("--------------------------------")

    patient_id = int(input("Enter patient ID: "))

    for patient in patients:

        if patient["id"] == patient_id:

            patients.remove(patient)

            save_patients()

            print("Patient deleted successfully!")

            return

    print("Patient not found.")


# ============================================================
# FUNCTION 11: SHOW PRIORITY SUMMARY
# ============================================================

def priority_summary():

    critical = 0
    urgent = 0
    normal = 0

    for patient in patients:

        if patient["priority"] == "CRITICAL":
            critical += 1

        elif patient["priority"] == "URGENT":
            urgent += 1

        else:
            normal += 1

    print("\n================================")
    print("       PRIORITY SUMMARY")
    print("================================")

    print("Critical patients:", critical)
    print("Urgent patients:", urgent)
    print("Normal patients:", normal)

    print("Total patients:", len(patients))


# ============================================================
# MAIN PROGRAM
# ============================================================

# Load previously saved patients
patients = load_patients()


# ============================================================
# MAIN MENU
# ============================================================

while True:

    print("\n\n==============================================")
    print("       EMERGENCY PATIENT PRIORITY SYSTEM")
    print("==============================================")

    print("1. Add Patient")
    print("2. Show All Patients")
    print("3. Search Patient")
    print("4. Update Patient")
    print("5. Delete Patient")
    print("6. Priority Summary")
    print("7. Exit")

    print("==============================================")

    choice = input("Enter your choice: ")

    if choice == "1":

        add_patient()

    elif choice == "2":

        show_all_patients()

    elif choice == "3":

        search_patient()

    elif choice == "4":

        update_patient()

    elif choice == "5":

        delete_patient()

    elif choice == "6":

        priority_summary()

    elif choice == "7":

        # Save before exiting
        save_patients()

        print("\nData saved successfully.")
        print("Thank you for using the Emergency Patient Priority System!")

        break

    else:

        print("\nInvalid choice. Please try again.")
