import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminCreateProblemPage extends StatefulWidget {
  final String apiUrl;

  const AdminCreateProblemPage({Key? key, required this.apiUrl}) : super(key: key);

  @override
  _AdminCreateProblemPageState createState() => _AdminCreateProblemPageState();
}

class _AdminCreateProblemPageState extends State<AdminCreateProblemPage> {
  String? selectedCategory;
  String? selectedLevel;

  final Map<String, int> categoryMapping = {
    '세금': 1,
    '자산관리': 2,
    '금융시사상식': 3,
  };

  final Map<String, int> levelMapping = {
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
  };

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void selectLevel(String level) {
    setState(() {
      selectedLevel = level;
    });
  }

  Future<void> createContent() async {
    if (selectedCategory == null || selectedLevel == null) {
      // Handle error: both category and level must be selected
      _showErrorDialog(context, '카테고리와 레벨을 모두 선택해야 합니다.');
      return;
    }

    int category = categoryMapping[selectedCategory]!;
    int level = levelMapping[selectedLevel]!;

    // Show the loading dialog
    _showLoadingDialog(context);

    final response = await http.post(
      Uri.parse('${widget.apiUrl}/create_content/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'label': category,
        'level': level,
      }),
    );

    // Close the loading dialog
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      _showSuccessDialog(context);
    } else {
      _showErrorDialog(context, '문제 생성에 실패했습니다.');
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('문제 생성 중...'),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('문제 생성 성공'),
          content: const Text('문제가 성공적으로 생성되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('오류'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.2;
    final double buttonHeight = MediaQuery.of(context).size.height * 0.1;

    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Center(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 2,
                        color: Color(0xFF4399FF),
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          '문제 생성',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          '카테고리',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CategoryButton(
                              title: '세금',
                              isSelected: selectedCategory == '세금',
                              onSelect: selectCategory,
                              width: buttonWidth,
                              height: buttonHeight,
                            ),
                            const SizedBox(width: 10),
                            CategoryButton(
                              title: '자산관리',
                              isSelected: selectedCategory == '자산관리',
                              onSelect: selectCategory,
                              width: buttonWidth,
                              height: buttonHeight,
                            ),
                            const SizedBox(width: 10),
                            CategoryButton(
                              title: '금융시사상식',
                              isSelected: selectedCategory == '금융시사상식',
                              onSelect: selectCategory,
                              width: buttonWidth,
                              height: buttonHeight,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          '레벨',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LevelButton(
                              level: '1',
                              isSelected: selectedLevel == '1',
                              onSelect: selectLevel,
                              width: buttonWidth * 0.5,
                              height: buttonHeight * 0.5,
                            ),
                            const SizedBox(width: 20),
                            LevelButton(
                              level: '2',
                              isSelected: selectedLevel == '2',
                              onSelect: selectLevel,
                              width: buttonWidth * 0.5,
                              height: buttonHeight * 0.5,
                            ),
                            const SizedBox(width: 20),
                            LevelButton(
                              level: '3',
                              isSelected: selectedLevel == '3',
                              onSelect: selectLevel,
                              width: buttonWidth * 0.5,
                              height: buttonHeight * 0.5,
                            ),
                            const SizedBox(width: 20),
                            LevelButton(
                              level: '4',
                              isSelected: selectedLevel == '4',
                              onSelect: selectLevel,
                              width: buttonWidth * 0.5,
                              height: buttonHeight * 0.5,
                            ),
                            const SizedBox(width: 20),
                            LevelButton(
                              level: '5',
                              isSelected: selectedLevel == '5',
                              onSelect: selectLevel,
                              width: buttonWidth * 0.5,
                              height: buttonHeight * 0.5,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: createContent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1C84FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 43),
                          ),
                          child: const Text(
                            '문제 생성하기',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/img/backbtn.png',
                      width: 45,
                      height: 45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function(String) onSelect;
  final double width;
  final double height;

  const CategoryButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onSelect,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(title),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 58, 98, 167)
              : const Color(0xFF53A2FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class LevelButton extends StatelessWidget {
  final String level;
  final bool isSelected;
  final Function(String) onSelect;
  final double width;
  final double height;

  const LevelButton({
    super.key,
    required this.level,
    required this.isSelected,
    required this.onSelect,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(level),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 58, 98, 167)
              : const Color(0xFF59A5FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            level,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
