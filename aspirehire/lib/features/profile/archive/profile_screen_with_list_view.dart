/*
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;
  final List<String> _labels = ["Home", "Search", "List", "Profile"];
  List<Map<String, dynamic>> experiences = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      experiences = [
        {"title": "Senior Fullstack Developer - Xceed", "subtitle": "May, 2023 - Currently"},
        {"title": "Senior Fullstack Developer - Oracle", "subtitle": "March 2021 - May 2023"},
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                const ProfileHeader(
                  avatarImage: 'assets/avatar.png',
                  onEditPressed: () {
                    // Handle edit button press
                  },
                ),
                const ProfileInfo(
                  name: "Mustafa Mahmoud",
                  jobTitle: "Senior Fullstack Developer",
                  phone: "+201000001100",
                  email: "MustafaMahmoud@gmail.com",
                  location: "Egypt, Cairo",
                ),
                const SizedBox(height: 20),
                Center(
                  child: WebLinks(
                    onAddLinkPressed: () {
                      // Handle add link button press
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Section(
                    title: "Experiences",
                    children: experiences.map((experience) {
                      return ListTile(
                        leading: const CircleAvatar(
                          radius: 5,
                          backgroundImage: AssetImage('assets/Ellipse.png'),
                        ),
                        title: Text(experience["title"]),
                        subtitle: Text(experience["subtitle"]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF013E5D),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home, _labels[0], 0),
            _buildNavItem(Icons.search, _labels[1], 1),
            _buildNavItem(Icons.list, _labels[2], 2),
            _buildNavItem(Icons.person, _labels[3], 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 0, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF013E5D) : Colors.white, size: 28),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF013E5D),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} */