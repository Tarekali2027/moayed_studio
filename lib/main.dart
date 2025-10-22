import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:js' as js;
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moayed Studio',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();

  late AnimationController _typingController;
  late Animation<double> _typingAnimation;
  
  static const String _nameText = 'Mahmoud Elmaoyed';
  static const String _titleText = 'Social Media Designer & Ads Creator';
  final int _nameLength = _nameText.length;
  final int _titleLength = _titleText.length;
  
  late AnimationController _imageFadeController;
  late Animation<double> _imageFade;
  
  bool _imageHovered = false;

  @override
  void initState() {
    super.initState();

    // إعداد أنميشن الآلة الكاتبة بالتسلسل
    // المدة الكلية: 1.5 ثانية للاسم + 0.5 تأخير + 2.0 للتخصص = 4.0 ثوانٍ (غير متكررة)
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000), 
    );
    _typingAnimation = CurvedAnimation(parent: _typingController, curve: Curves.linear);

    _typingController.forward();

    // إعداد أنميشن الصورة
    _imageFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900), 
    );
    
    _imageFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _imageFadeController, curve: Curves.easeOut),
    );

    _imageFadeController.forward();
  }

  @override
  void dispose() {
    _typingController.dispose();
    _imageFadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getVisibleText(String text, int length, double animationValue, double start, double end) {
    if (animationValue < start) return '';
    if (animationValue > end) return text;
    
    final normalizedValue = (animationValue - start) / (end - start);
    final visibleChars = (normalizedValue * length).round();
    return text.substring(0, min(visibleChars, length));
  }

  String _getVisibleName(double animationValue) {
    return _getVisibleText(_nameText, _nameLength, animationValue, 0.0, 0.375);
  }

  String _getVisibleTitle(double animationValue) {
    return _getVisibleText(_titleText, _titleText.length, animationValue, 0.475, 1.0);
  }

  void _updateHoverState(bool isHovered) {
    setState(() {
      _imageHovered = isHovered;
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (uri.scheme == 'http' || uri.scheme == 'https' || uri.scheme == 'mailto' || uri.scheme == 'tel') {
      try {
        js.context.callMethod('open', [url, '_blank']);
        return;
      } catch (e) {
        debugPrint('Dart:js failure, falling back to url_launcher: $e');
      }
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _scrollToKey(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.white.withOpacity(0.9);
    final Color subTextColor = Colors.white70;
    final Color accentColor = const Color(0xFF00C896);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Moayed Studio",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  ),
                  child: const Text("Home", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () => _scrollToKey(_aboutKey),
                  child: const Text("About Me", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () => _scrollToKey(_skillsKey),
                  child: const Text("Skills", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () => _scrollToKey(_projectsKey),
                  child: const Text("Projects", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(width: 30),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E14), Color(0xFF1C1F26), Color(0xFF123C34)],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // ================= HOME SECTION =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 120),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isWide = constraints.maxWidth > 800;
                    
                    final Widget imageContent = ClipRRect(
                      borderRadius: BorderRadius.circular(isWide ? 60 : 20),
                      child: Image.asset(
                        'assets/home.jpg',
                        height: isWide ? 550 : constraints.maxWidth * 0.75, 
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );

                    final Widget hoverableImage = MouseRegion(
                      onEnter: (_) => _updateHoverState(true),
                      onExit: (_) => _updateHoverState(false),
                      child: FadeTransition(
                        opacity: _imageFade,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          transform: Matrix4.identity()..scale(_imageHovered ? 1.05 : 1.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(isWide ? 60 : 20),
                            boxShadow: _imageHovered
                                ? [BoxShadow(color: accentColor.withOpacity(0.5), blurRadius: 30, spreadRadius: 5)]
                                : [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)],
                          ),
                          child: imageContent,
                        ),
                      ),
                    );

                    return isWide
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 4,
                                child: hoverableImage,
                              ),
                              const SizedBox(width: 60),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _typingAnimation,
                                      builder: (context, child) {
                                        final String visibleName = _getVisibleName(_typingAnimation.value);
                                        return Text(
                                          visibleName,
                                          style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: accentColor),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    AnimatedBuilder(
                                      animation: _typingAnimation,
                                      builder: (context, child) {
                                        final String visibleTitle = _getVisibleTitle(_typingAnimation.value);
                                        return Text(
                                          visibleTitle,
                                          style: GoogleFonts.poppins(fontSize: 22, color: subTextColor),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 40),
                                    Row(
                                      children: [
                                        AnimatedIconButton(color: Colors.greenAccent, icon: FontAwesomeIcons.whatsapp, onPressed: () => _launchUrl('https://api.whatsapp.com/send?phone=201092257192')),
                                        const SizedBox(width: 20),
                                        AnimatedIconButton(color: Colors.purpleAccent, icon: FontAwesomeIcons.instagram, onPressed: () => _launchUrl('https://www.instagram.com/mahmoud_khalf1')),
                                        const SizedBox(width: 20),
                                        AnimatedIconButton(color: Colors.blueAccent, icon: FontAwesomeIcons.behance, onPressed: () => _launchUrl('https://www.behance.net/mahmoudkhalf122')),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              hoverableImage,
                              const SizedBox(height: 40),
                              Column(
                                children: [
                                  AnimatedBuilder(
                                    animation: _typingAnimation,
                                    builder: (context, child) {
                                      final String visibleName = _getVisibleName(_typingAnimation.value);
                                      return Text(
                                        visibleName,
                                        style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold, color: accentColor),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  AnimatedBuilder(
                                    animation: _typingAnimation,
                                    builder: (context, child) {
                                      final String visibleTitle = _getVisibleTitle(_typingAnimation.value);
                                      return Text(
                                        visibleTitle,
                                        style: GoogleFonts.poppins(fontSize: 18, color: subTextColor),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedIconButton(color: Colors.greenAccent, icon: FontAwesomeIcons.whatsapp, onPressed: () => _launchUrl('https://api.whatsapp.com/send?phone=201092257192')),
                                      const SizedBox(width: 20),
                                      AnimatedIconButton(color: Colors.purpleAccent, icon: FontAwesomeIcons.instagram, onPressed: () => _launchUrl('https://www.instagram.com/mahmoud_khalf1')),
                                      const SizedBox(width: 20),
                                      AnimatedIconButton(color: Colors.blueAccent, icon: FontAwesomeIcons.behance, onPressed: () => _launchUrl('https://www.behance.net/mahmoudkhalf122')),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                  },
                ),
              ),
              // ================= ABOUT ME =================
              Container(
                key: _aboutKey,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
                width: double.infinity,
                color: Colors.black.withOpacity(0.15),
                child: Column(
                  children: [
                    Text("About Me", style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold, color: accentColor)),
                    const SizedBox(height: 30),
                    Text(
                      'مصمم جرافيك بخبرة أكثر من 4 سنوات في تصميم السوشيال ميديا، '
                      'وخبرة 6 شهور في تصميم الإعلانات الموشن جرافيك.\n\n'
                      'أتميز بابتكار تصاميم عصرية وجذابة تساعد العلامات التجارية على الظهور بشكل احترافي، '
                      'وأركز دائمًا على التفاصيل والألوان والتوازن البصري.\n\n'
                      'أستخدم أدوات التصميم التالية: Photoshop, Illustrator, CapCut, Wesco.\n\n'
                      'أسعى لتقديم تصاميم تدمج بين الإبداع والبساطة وتترك انطباعًا قويًا.',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.poppins(fontSize: 18, color: textColor, height: 1.8),
                    ),
                  ],
                ),
              ),
              // ================= SKILLS =================
              Container(
                key: _skillsKey,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
                width: double.infinity,
                color: Colors.black.withOpacity(0.1),
                child: Column(
                  children: [
                    Text("My Skills", style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold, color: accentColor)),
                    const SizedBox(height: 40),
                    Wrap(
                      spacing: 30,
                      runSpacing: 30,
                      alignment: WrapAlignment.center,
                      children: const [
                        AnimatedSkillCard(icon: FontAwesomeIcons.paintbrush, label: "Photoshop"),
                        AnimatedSkillCard(icon: FontAwesomeIcons.penNib, label: "Illustrator"),
                        AnimatedSkillCard(icon: FontAwesomeIcons.video, label: "CapCut"),
                        AnimatedSkillCard(icon: FontAwesomeIcons.palette, label: "Wesco"),
                      ],
                    ),
                  ],
                ),
              ),
              // ================= PROJECTS SECTION =================
              Container(
                key: _projectsKey,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                child: Column(
                  children: [
                    Text("My Projects", style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold, color: accentColor)),
                    const SizedBox(height: 40),
                    Wrap(
                      spacing: 30,
                      runSpacing: 30,
                      alignment: WrapAlignment.center,
                      children: [
                        HoverableProjectCard(title: "finearts course", imagePath: "assets/finearts course.jpg", link: "https://www.behance.net/gallery/201338669/finearts-course"),
                        HoverableProjectCard(title: "isterad", imagePath: "assets/isterad.jpg", link: "https://www.behance.net/gallery/195993525/isterad"),
                        HoverableProjectCard(title: "LOGOFOLIO", imagePath: "assets/LOGOFOLIO.jpg", link: "https://www.behance.net/gallery/209530301/LOGOFOLIO"),
                        HoverableProjectCard(title: "majalah web", imagePath: "assets/majalah web.jpg", link: "https://www.behance.net/gallery/191459635/majalah-web"),
                        HoverableProjectCard(title: "mashura social midea designs", imagePath: "assets/mashura social midea designs.jpg", link: "https://www.behance.net/gallery/233205893/mashura-social-midea-designs"),
                        HoverableProjectCard(title: "mk identity", imagePath: "assets/mk identity.jpg", link: "https://www.behance.net/gallery/193603713/mk-identity"),
                        HoverableProjectCard(title: "new logo", imagePath: "assets/new logo.jpg", link: "https://www.behance.net/gallery/189554999/new-logo"),
                        HoverableProjectCard(title: "Round pinch UI and logo design", imagePath: "assets/Round pinch UI and logo design.jpg", link: "https://www.behance.net/gallery/201796207/Round-pinch-UI-and-logo-design"),
                        HoverableProjectCard(title: "the rekruiters designs", imagePath: "assets/the rekruiters designs.jpg", link: "https://www.behance.net/gallery/205232219/the-rekruiters-designs"),
                        HoverableProjectCard(title: "صندوق دعم العمل الأهلي", imagePath: "assets/صندوق دعم العمل الأهلي.jpg", link: "https://www.behance.net/gallery/208402593/_"),
                        HoverableProjectCard(title: "كوكب الفن", imagePath: "assets/كوكب الفن.jpg", link: "https://www.behance.net/gallery/205751853/_"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= PROJECT CARD WITH HOVER EFFECT =================
class HoverableProjectCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final String link;

  const HoverableProjectCard({super.key, required this.title, required this.imagePath, required this.link});

  @override
  State<HoverableProjectCard> createState() => _HoverableProjectCardState();
}

class _HoverableProjectCardState extends State<HoverableProjectCard> with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openLink() async {
    if (context.findAncestorStateOfType<_HomePageState>()?._launchUrl(widget.link) == null) {
      final Uri uri = Uri.parse(widget.link);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch ${widget.link}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: _openLink,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 350,
              height: 400,
              transform: Matrix4.identity()..scale(_hovered ? 1.05 : 1.0)..translate(0, _hovered ? -5 : 0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
                boxShadow: _hovered
                    ? [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 20, spreadRadius: 3)]
                    : [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(widget.imagePath, height: 250, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(widget.title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C896),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _openLink,
                      child: const Text("View", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= SKILL CARD WITH ICON =================
class AnimatedSkillCard extends StatefulWidget {
  final IconData icon;
  final String label;

  const AnimatedSkillCard({super.key, required this.icon, required this.label});

  @override
  State<AnimatedSkillCard> createState() => _AnimatedSkillCardState();
}

class _AnimatedSkillCardState extends State<AnimatedSkillCard> with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // دالة تُرجع وصف الخبرة بناءً على اسم المهارة
  String _getSkillDescription(String skill) {
    switch (skill) {
      case "Photoshop":
        return "خبرتي في **Photoshop** تمكنني من معالجة الصور باحترافية عالية، وتصميم إعلانات السوشيال ميديا المعقدة، والعمل على دمج العناصر بشكل واقعي ومقنع، بالإضافة إلى تعديل الألوان والإضاءة بدقة متناهية.";
      case "Illustrator":
        return "أمتلك خبرة ممتازة في استخدام **Illustrator** لتصميم الهويات البصرية والشعارات المتجهة (Vector) التي يمكن تكبيرها لأي حجم دون فقدان الجودة، ورسومات Infographics، والتصاميم المعتمدة على الأشكال الهندسية والخطوط الواضحة.";
      case "CapCut":
        return "خبرتي في **CapCut** تركز على صناعة إعلانات الفيديو السريعة والمحتوى المرئي المتحرك (Motion Graphics)، مع القدرة على إضافة تأثيرات الانتقال، والموسيقى، وتعديل سرعة المقاطع لإنتاج محتوى جذاب وعصري يناسب منصات السوشيال ميديا.";
      case "Wesco":
        return "أستخدم **Wesco** لتنسيق وتوحيد الألوان والخطوط في التصاميم، مما يضمن الاتساق البصري عبر جميع الحملات الإعلانية والمواد التسويقية، وهو ما يُعتبر أساسياً لخلق هوية بصرية قوية ومميزة للعلامات التجارية.";
      default:
        return "هذه المهارة أساسية ومهمة في مجال التصميم الجرافيكي.";
    }
  }

  void _showSkillDialog(BuildContext context) {
    final skillDescription = _getSkillDescription(widget.label);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF00C896))),
              const SizedBox(height: 20),
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Text(
                  "خبرتي في هذه المهارة:",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Text(
                  skillDescription,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () => _showSkillDialog(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 160,
              height: 200,
              transform: Matrix4.identity()..scale(_hovered ? 1.05 : 1.0)..translate(0.0, _hovered ? -4.0 : 0.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(_hovered ? 0.25 : 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24, width: 1.2),
                boxShadow: _hovered ? [BoxShadow(color: const Color(0xFF00C896).withOpacity(0.5), blurRadius: 20, spreadRadius: 3)] : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(widget.icon, size: 60, color: Colors.white),
                  const SizedBox(height: 15),
                  Text(widget.label, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= ANIMATED ICON BUTTON =================
class AnimatedIconButton extends StatefulWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const AnimatedIconButton({super.key, required this.color, required this.icon, required this.onPressed});

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.identity()..scale(_hovered ? 1.2 : 1.0)..translate(0.0, _hovered ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(_hovered ? 0.9 : 1.0),
          shape: BoxShape.circle,
          boxShadow: _hovered ? [BoxShadow(color: widget.color.withOpacity(0.6), blurRadius: 20, spreadRadius: 2)] : [],
        ),
        child: IconButton(onPressed: widget.onPressed, icon: FaIcon(widget.icon, color: Colors.black, size: 26)),
      ),
    );
  }
}
