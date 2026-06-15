# FarmConnect 🌾

A Flutter-based marketplace app connecting local farmers directly with consumers. Browse fresh produce, dairy, grains, and more from nearby farmers.

## ✨ Features

- **Browse Products** – Fresh fruits, vegetables, grains, dairy, herbs & poultry
- **Category Filters** – Quickly find what you need
- **Shopping Cart** – Add & manage items before ordering
- **Sell Products** – Farmers can list their own products
- **User Auth** – Login / Sign up via Supabase
- **Dark Mode** – Toggle between light & dark themes
- **Farmer Profiles** – View farmer details & contact info
- **Responsive UI** – Works on mobile, tablet, web & desktop

## 🖼 Screenshots

(Add screenshots here once available)

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.x or higher)
- Dart (comes with Flutter)
- A code editor (VS Code, Android Studio, or IntelliJ)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Sathish-192321148/PDD.git
   cd PDD
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For mobile (connected device / emulator)
   flutter run

   # For web
   flutter run -d chrome

   # For desktop (Windows/Linux/macOS)
   flutter run -d windows
   flutter run -d linux
   flutter run -d macos
   ```

4. **Build for production**
   ```bash
   flutter build apk          # Android
   flutter build ios           # iOS
   flutter build web           # Web
   flutter build windows       # Windows
   flutter build linux         # Linux
   flutter build macos         # macOS
   ```

## 🏗 Project Structure

```
lib/
├── main.dart                  # App entry point & route definitions
├── models/
│   └── product.dart           # Product data model
├── screens/
│   ├── welcome_screen.dart    # Onboarding / welcome screen
│   ├── login_screen.dart      # User login
│   ├── signup_screen.dart     # User registration
│   ├── home_screen.dart       # Main product listing
│   ├── categories_screen.dart # Category-based browsing
│   ├── cart_screen.dart       # Shopping cart
│   ├── sell_products_screen.dart # List products for sale
│   ├── profile_screen.dart    # User profile
│   ├── product_detail_screen.dart # Product details page
│   ├── basket_screen.dart     # Basket / order summary
│   ├── buy_products_screen.dart # Buy flow
│   ├── farmer_details_screen.dart # Farmer info
│   ├── available_farmers_screen.dart # Farmer directory
│   ├── category_products_screen.dart # Products by category
│   ├── change_password_screen.dart # Password management
│   ├── about_app_screen.dart  # App info
│   └── settings_screen.dart   # App settings
├── services/
│   ├── supabase_service.dart  # Supabase client config
│   ├── app_data.dart          # In-memory product data
│   ├── user_data.dart         # User data management
│   └── current_user.dart      # Current user state
├── theme/
│   ├── app_theme.dart         # Light & dark theme definitions
│   └── theme_provider.dart    # Theme state management
└── navigation/
    └── main_shell.dart        # Bottom navigation shell
```

## 🛠 Tech Stack

- **Flutter** – Cross-platform UI framework
- **Supabase** – Backend / Authentication
- **Google Fonts** – Typography
- **Lottie** – Animations
- **Cached Network Image** – Image loading & caching
- **Carousel Slider** – Product carousels
- **Shimmer** – Loading placeholders

## 🔐 Environment

The app connects to a Supabase backend. Update credentials in `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

## 🤝 Contributing

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is for educational/demonstration purposes.

## 🙏 Acknowledgments

- Built as part of a PDD (Product Design & Development) project
- Thanks to all the farmers and local producers who inspired this app
