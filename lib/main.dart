import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// =====================================================================
// FitFuel - gym calories tracker (classroom demo)
// Flow: Start page -> Login page (with validation) -> Dashboard
// No packages, no backend, no real login. Everything is in this file.
// =====================================================================

// ---------------------------------------------------------------
// 1. COLOURS - the same theme as the Figma design
// ---------------------------------------------------------------
class AppColors {
  static const Color ink = Color(0xFF0B1330); // dark text / dark background
  static const Color blue = Color(0xFF2547F5); // main colour (buttons, cards)
  static const Color mist = Color(0xFFE4EAFF); // soft blue (welcome card)
  static const Color background = Color(0xFFF6F8FF); // light screen background
  static const Color line = Color(0xFFDCE3FA); // borders, empty bars
  static const Color amber = Color(0xFFFFB020); // calories burned
  static const Color muted = Color(0xFF5B6586); // secondary text
  static const Color coral = Color(0xFFE5484D); // error colour
  static const Color white = Color(0xFFFFFFFF);

  // White with transparency (used on dark / blue backgrounds)
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white22 = Color(0x38FFFFFF);
  static const Color white35 = Color(0x59FFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white85 = Color(0xD9FFFFFF);
}

// ---------------------------------------------------------------
// 2. DEMO DATA - fixed sample numbers (no database needed)
// ---------------------------------------------------------------
class DemoData {
  static const int goal = 2200;
  static const int eaten = 1450;
  static const int burned = 420;
  static int get left => goal - eaten;
}

// Turns 2200 into "2,200"
String formatNumber(int number) {
  return number.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (Match m) => '${m[1]},',
      );
}

// ---------------------------------------------------------------
// 3. APP START
// ---------------------------------------------------------------
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFuel',
      debugShowCheckedModeBanner: false, // hides the red DEBUG ribbon
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.blue,
        ),
      ),
      home: const StartPage(), // the first page the user sees
    );
  }
}

// ---------------------------------------------------------------
// 4. REUSABLE BUTTONS (rounded, full width = responsive)
// ---------------------------------------------------------------
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // stretches to the screen width
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        child: Text(label),
      ),
    );
  }
}

class OutlineBlueButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const OutlineBlueButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.blue,
          backgroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.blue, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        child: Text(label),
      ),
    );
  }
}

// ---------------------------------------------------------------
// 5. START PAGE (dark screen with a dumbbell drawing)
// ---------------------------------------------------------------
class StartPage extends StatelessWidget {
  const StartPage({super.key});

  // A small rounded label such as "Meals"
  Widget _pill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // light status-bar icons because this screen is dark
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.ink,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Leave room for the content on compact screens; the page scrolls
              // when the available height is too short for the full introduction.
              final double heroHeight = constraints.maxHeight < 640
                  ? 180
                  : (constraints.maxHeight * 0.42).clamp(240.0, 360.0).toDouble();

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: heroHeight,
                      child: CustomPaint(
                        painter: HeroPainter(),
                        child: const SizedBox.expand(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _pill('Meals'),
                        _pill('Workouts'),
                        _pill('Goals'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'FitFuel',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Every rep needs fuel.',
                      style: TextStyle(
                        color: AppColors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Log your meals and track your workouts. '
                      'See how much fuel is left today.',
                      style: TextStyle(
                        color: AppColors.white85,
                        fontSize: 17,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'Start',
                      height: 64,
                      onPressed: () {
                        // Open the Login page on top of this page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Draws the blue circle, the dumbbell and the small dots
class HeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // "s" shrinks the drawing on small screens so it always fits
    final double s = min(size.width / 370, size.height / 360);
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Thin outer ring
    canvas.drawCircle(
      center,
      178 * s,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.white10,
    );

    // Big blue circle
    canvas.drawCircle(center, 150 * s, Paint()..color = AppColors.blue);

    // Dumbbell (tilted a little)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-25 * pi / 180);

    void block(double x, double y, double w, double h, double r, Color color) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          x * s,
          y * s,
          (x + w) * s,
          (y + h) * s,
          Radius.circular(r * s),
        ),
        Paint()..color = color,
      );
    }

    block(-70, -7, 140, 14, 7, AppColors.white); // bar
    block(45, -44, 22, 88, 8, AppColors.white); // right inner plate
    block(69, -32, 18, 64, 7, AppColors.amber); // right outer plate
    block(89, -16, 12, 32, 5, AppColors.white); // right end cap
    block(-67, -44, 22, 88, 8, AppColors.white); // left inner plate
    block(-87, -32, 18, 64, 7, AppColors.amber); // left outer plate
    block(-101, -16, 12, 32, 5, AppColors.white); // left end cap
    canvas.restore();

    // Small amber dot (top right)
    canvas.drawCircle(
      center + Offset(135 * s, -125 * s),
      16 * s,
      Paint()..color = AppColors.amber,
    );

    // Small ring (bottom left)
    canvas.drawCircle(
      center + Offset(-131 * s, 127 * s),
      14 * s,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = AppColors.white35,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------
// 6. LOGIN PAGE - with validation and error messages
// StatefulWidget because the screen changes (errors appear/disappear)
// ---------------------------------------------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // The key lets us ask the Form: "are all fields valid?"
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers let us read what the user typed
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // After the first failed login, errors update live while typing
  bool _showLiveErrors = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ----- VALIDATION RULES -----
  // Each function returns an error message, or null when the value is OK.
  String? _validateName(String? value) {
    final String name = (value ?? '').trim();
    if (name.isEmpty) {
      return 'Please enter your name.';
    }
    if (name.length < 2) {
      return 'Name must be at least 2 characters.';
    }
    if (RegExp(r'[0-9]').hasMatch(name)) {
      return 'Name cannot contain numbers.';
    }
    return null; // null means "no error"
  }

  String? _validatePassword(String? value) {
    final String password = value ?? '';
    if (password.isEmpty) {
      return 'Please enter your password.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  // ----- LOGIN BUTTON PRESSED -----
  void _handleLogin() {
    FocusScope.of(context).unfocus(); // close the keyboard

    // validate() runs both validators and shows the red error messages
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      // Something is wrong: stay on this page and keep showing errors
      setState(() {
        _showLiveErrors = true;
      });
      return;
    }

    // Everything is OK: go to the Dashboard.
    // pushAndRemoveUntil removes the old pages so Back cannot return here.
    final String name = _nameController.text.trim();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage(userName: name)),
      (route) => false,
    );
  }

  // Look of the text fields (white box, rounded, red border on error)
  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
  }) {
    OutlineInputBorder border(Color color, [double width = 1.5]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 16),
      prefixIcon: Icon(icon, color: AppColors.muted),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: border(AppColors.line),
      enabledBorder: border(AppColors.line),
      focusedBorder: border(AppColors.blue, 2),
      errorBorder: border(AppColors.coral),
      focusedErrorBorder: border(AppColors.coral, 2),
      errorStyle: const TextStyle(
        color: AppColors.coral,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            // Soft half-circle decoration at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 150,
              child: IgnorePointer(
                child: CustomPaint(painter: HalfRingPainter()),
              ),
            ),
            SafeArea(
              // Scrolling prevents overflow errors when the keyboard opens
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button (round)
                    Material(
                      color: AppColors.white,
                      shape: const CircleBorder(
                        side: BorderSide(color: AppColors.line, width: 1.5),
                      ),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(
                            Icons.chevron_left,
                            size: 28,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Enter your name and password.',
                      style: TextStyle(color: AppColors.muted, fontSize: 16),
                    ),
                    const SizedBox(height: 32),

                    // The Form groups both fields so we can validate together
                    Form(
                      key: _formKey,
                      autovalidateMode: _showLiveErrors
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Name'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            validator: _validateName,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: _fieldDecoration(
                              hint: 'Your name',
                              icon: Icons.person_outline,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _label('Password'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            validator: _validatePassword,
                            obscureText: true, // hides the password
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) => _handleLogin(),
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: _fieldDecoration(
                              hint: 'Your password',
                              icon: Icons.lock_outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(label: 'Login', onPressed: _handleLogin),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Classroom demo: use any name and a password '
                        'with 6 or more characters.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Draws the faint half circle at the bottom of the Login page
class HalfRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height),
      radius: 130,
    );
    canvas.drawArc(
      rect,
      pi,
      pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 28
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFFE8EDFD),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------
// 7. DASHBOARD PAGE
// Receives the user's name from the Login page.
// ---------------------------------------------------------------
class DashboardPage extends StatelessWidget {
  final String userName;

  const DashboardPage({super.key, required this.userName});

  // Today's date as text, for example "Thursday, 22 October"
  String _todayText() {
    const List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final DateTime now = DateTime.now();
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  // One row of the Macros card: label, progress bar, value
  Widget _macroRow(String label, double fraction, Color color, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          SizedBox(
            width: 62,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fraction,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 82,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String initial =
        userName.isNotEmpty ? userName[0].toUpperCase() : '?';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----- Header: greeting + avatar -----
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $userName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _todayText(),
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.blue,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ----- Welcome card -----
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.mist,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome back!',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${DemoData.left} kcal left to reach '
                              "today's goal.",
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.blue,
                        child: Icon(Icons.bolt, color: AppColors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ----- Calorie gauge card (blue) -----
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      const CalorieGauge(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Burned',
                                style: TextStyle(
                                  color: AppColors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${DemoData.burned} kcal',
                                style: const TextStyle(
                                  color: AppColors.amber,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Left',
                                style: TextStyle(
                                  color: AppColors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${DemoData.left} kcal',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ----- Macros card (white) -----
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.line, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Macros today',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      _macroRow('Protein', 0.70, AppColors.blue, '98 / 140 g'),
                      _macroRow('Carbs', 0.64, AppColors.amber, '160 / 250 g'),
                      _macroRow('Fat', 0.60, AppColors.ink, '42 / 70 g'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ----- Logout button -----
                OutlineBlueButton(
                  label: 'Logout',
                  onPressed: () {
                    // Back to the Start page and remove all other pages
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartPage(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// 8. CALORIE GAUGE (half circle, like a car fuel gauge)
// ---------------------------------------------------------------
class CalorieGauge extends StatelessWidget {
  const CalorieGauge({super.key});

  // Small number under each end of the gauge
  Widget _endLabel(String text) {
    return SizedBox(
      width: 40,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double fraction = DemoData.eaten / DemoData.goal;

    return SizedBox(
      width: 240,
      child: Column(
        children: [
          SizedBox(
            height: 130,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: GaugePainter(fraction: fraction)),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 46,
                  child: Column(
                    children: [
                      Text(
                        formatNumber(DemoData.eaten),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const Text(
                        'kcal eaten',
                        style: TextStyle(
                          color: AppColors.white85,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _endLabel('0'),
              _endLabel(formatNumber(DemoData.goal)),
            ],
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double fraction; // 0.0 = empty, 1.0 = full

  GaugePainter({required this.fraction});

  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 100;
    const double strokeWidth = 22;
    final Offset center = Offset(size.width / 2, 115);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Empty track (the full half circle, faded)
    final Paint trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.white22;

    // Filled part (how much was eaten)
    final Paint fillPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.white;

    // In Flutter, angle "pi" points left; a positive sweep goes clockwise
    canvas.drawArc(rect, pi, pi, false, trackPaint);
    canvas.drawArc(rect, pi, pi * fraction, false, fillPaint);

    // Small tick marks inside the arc
    final Paint tickPaint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.white35;

    const double tickOuter = radius - strokeWidth / 2 - 6;
    const double tickInner = tickOuter - 7;
    for (int i = 0; i <= 10; i++) {
      final double angle = pi + i * pi / 10;
      final Offset direction = Offset(cos(angle), sin(angle));
      canvas.drawLine(
        center + direction * tickInner,
        center + direction * tickOuter,
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
