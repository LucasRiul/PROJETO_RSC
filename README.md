# Financial Management App

This is a financial management application built using Flutter. The app allows users to add, view, and categorize their financial transactions. The project is designed to provide an intuitive interface for managing personal finances, including detailed dashboards and filtering capabilities.

## Features

- **Add Financial Transactions:** Users can add income or expense entries with descriptions, dates, categories, and amounts.
- **Categorization:** Transactions can be grouped by categories, with options to view summaries.
- **Dashboard:** Visualize financial data with charts and lists, grouped by categories.
- **Filtering:** Filter transactions by type (income or expense), month, and year.
- **Responsive UI:** Ensures smooth user experience across devices.

## Technologies Used

- **Flutter**: Framework for building cross-platform mobile applications.
- **Dart**: Programming language used for Flutter development.
- **Firebase**: Backend services for database and storage.
- **Custom Widgets**: Implements reusable components like dropdowns, radio buttons, and text fields.
- **Libraries:**
  - `collection` for data grouping.
  - `tutorial_coach_mark` for guided user onboarding.
  - `text_input_mask` for input formatting.

## Getting Started

### Prerequisites

1. **Flutter SDK**: Install Flutter by following the [official documentation](https://flutter.dev/docs/get-started/install).
2. **Firebase Setup**:
   - Configure Firebase for the app.
   - Ensure proper security rules are applied.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repository/financial-management-app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd financial-management-app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Configure Firebase:
   - Add your `google-services.json` or `GoogleService-Info.plist` files.
   - Update Firestore and authentication configurations as needed.

### Running the App

Run the following command to start the app:
```bash
flutter run
```

## Folder Structure

- `lib`
  - `data`: Contains local data files (e.g., JSON for categories).
  - `models`: Data models for the app.
  - `screens`: UI screens for different parts of the app.
  - `widgets`: Reusable components like buttons, dropdowns, and dialogs.
  - `controllers`: Business logic and data handling.

## Key Challenges Addressed

- **Dynamic Dialog Layouts:** Used `SingleChildScrollView` for dynamic content inside dialogs.
- **State Management:** Implemented `FutureBuilder` and custom state management for Firebase interactions.
- **User Onboarding:** Provided guided tours using `tutorial_coach_mark`.
- **Error Handling:** Included meaningful error messages for invalid inputs and Firebase connectivity issues.

## Future Improvements

- Add support for multiple currencies.
- Implement authentication for user-specific data.
- Improve visualizations with advanced charting options.

## Contributing

Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add YourFeature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contact

For questions or suggestions, feel free to contact the project maintainer at [lucasriul85@gmail.com](mailto:your-email@example.com).

