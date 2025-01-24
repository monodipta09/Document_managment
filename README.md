Here's the updated README file with the additional note about customizing project paths based on the user's computer setup:

---

# Document Management System

This project is a Document Management System developed using Flutter.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Updating Dependencies](#updating-dependencies)
- [License](#license)

## Introduction

The Document Management System is designed to help organizations efficiently manage, store, and retrieve documents. Built with Flutter, it offers cross-platform compatibility, allowing users to access the system on various devices.

## Features

- **Document Storage**: Securely upload and store documents.
- **Document Retrieval**: Easily search and retrieve stored documents.
- **User Management**: Manage user access and permissions.
- **Version Control**: Maintain and track document versions.
- **Audit Trail**: Monitor document access and modifications.

## Installation

To set up the project locally, follow these steps:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/monodipta09/Document_managment.git
   ```

2. **Navigate to the project directory**:

   ```bash
   cd Document_managment
   ```

3. **Install dependencies**:

   Ensure you have Flutter installed. Then, run:

   ```bash
   flutter pub get
   ```

4. **Run the application**:

   ```bash
   flutter run
   ```

## Usage

Once the application is running, you can:

- **Upload Documents**: Add new documents to the system.
- **Search Documents**: Use the search functionality to find documents.
- **Manage Users**: Add or remove users and assign permissions.
- **Track Changes**: View the history of document modifications.

## Updating Dependencies

This project includes a script for updating dependencies across multiple Flutter projects. Follow these steps to use it:

1. **Open PowerShell**:
   - Press `Win + X` and select **Windows PowerShell** or **Windows PowerShell (Admin)**.

2. **Copy and Paste the Code**:
   - Use the following code snippet directly in PowerShell:

     ```powershell
     # List of Flutter project paths
     $apps = @(
         "C:\Users\diasa\StudioProjects\ikon_demo",
         "C:\Users\diasa\StudioProjects\login_page",
         "C:\Users\diasa\StudioProjects\document_management_main"
         # Add more paths as needed
     )

     # Loop through each app directory and run flutter pub get
     foreach ($app in $apps) {
         Write-Host "Updating dependencies in $app..."
         Set-Location -Path $app
         flutter pub get
     }

     Write-Host "All apps updated!"
     ```

3. **Customize the Paths**:
   - Replace the paths in the `$apps` array with the locations of your Flutter projects stored on your computer. Ensure each path points to the root folder of a Flutter project, where the `pubspec.yaml` file is located. Example:

     ```powershell
     $apps = @(
         "C:\Users\YourUsername\StudioProjects\YourProject1",
         "D:\FlutterProjects\YourProject2"
     )
     ```

4. **Run the Code**:
   - Press **Enter** after pasting the code. The script will:
     - Navigate to each project directory listed in `$apps`.
     - Run `flutter pub get` to update dependencies.

5. **Verify Updates**:
   - Check the `pubspec.lock` file of each project to confirm that dependencies have been updated.

6. **Add More Projects**:
   - To include additional Flutter projects, simply add their paths to the `$apps` array in the script.

## License

This project is proprietary and is the property of KEROSS. Unauthorized access, use, or distribution is strictly prohibited. For more information, visit [KEROSS](https://www.keross.com).Please, visit the LICENSE file for more instruction.

---

This version clearly instructs the user to customize the paths to match their system's directory structure before running the script.
