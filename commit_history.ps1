git config user.email "yeatasim-cse9@users.noreply.github.com"
git config user.name "yeatasim-cse9"
git init

# 1
git add README.md
git commit -m "Initial commit with README"

# 2
git add .gitignore
git commit -m "Add .gitignore"

# 3
git add pubspec.yaml pubspec.lock analysis_options.yaml
git commit -m "Initialize Flutter project configuration"

# 4
git add android/
git commit -m "Set up Android platform scaffold"

# 5
git add ios/
git commit -m "Set up iOS platform scaffold"

# 6
git add web/
git commit -m "Set up Web platform scaffold"

# 7
git add windows/
git commit -m "Set up Windows platform scaffold"

# 8
git add linux/
git commit -m "Set up Linux platform scaffold"

# 9
git add macos/
git commit -m "Set up macOS platform scaffold"

# 10
git add test/
git commit -m "Add basic tests directory"

# 11
git add firebase.json .firebaserc
git commit -m "Configure Firebase settings"

# 12
git add firestore.rules
git commit -m "Add Firestore security rules"

# 13
git add firestore.indexes.json
git commit -m "Add Firestore indexes configuration"

# 14
git add lib/models/user_model.dart
git commit -m "Implement user data model"

# 15
git add lib/models/recipe_model.dart
git commit -m "Implement recipe data model"

# 16
git add lib/services/firebase_service.dart
git commit -m "Add base Firebase service implementation"

# 17
git add lib/services/firebase_auth_service.dart
git commit -m "Add Firebase authentication service"

# 18
git add lib/providers/auth_provider.dart
git commit -m "Implement authentication state provider"

# 19
git add lib/providers/cart_provider.dart
git commit -m "Implement shopping cart provider"

# 20
git add lib/providers/favorites_provider.dart
git commit -m "Implement favorites state provider"

# 21
git add lib/providers/recipe_provider.dart
git commit -m "Implement recipe state provider"

# 22
git add lib/widgets/custom_button.dart
git commit -m "Create reusable custom button widget"

# 23
git add lib/widgets/custom_text_field.dart
git commit -m "Create reusable custom text field widget"

# 24
git add lib/screens/login_screen.dart
git commit -m "Add login screen UI"

# 25
git add lib/screens/signup_screen.dart
git commit -m "Add signup screen UI"

# 26
git add lib/screens/home_screen.dart
git commit -m "Build main home screen dashboard"

# 27
git add lib/screens/recipe_detail_screen.dart
git commit -m "Add detailed recipe view screen"

# 28
git add lib/firebase_options.dart
git commit -m "Configure Firebase options for Flutter"

# 29
git add lib/main.dart
git commit -m "Set up main entrypoint"

# 30
git add .
git commit -m "Final repository setup and clean up"

git branch -M main
git remote add origin https://github.com/yeatasim-cse9/Restaurent.git
git push -u origin main
