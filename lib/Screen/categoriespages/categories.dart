
import 'package:flutter/material.dart';
import 'package:relt/Screen/categoriespages/mencategory.dart';
import 'package:relt/Screen/categoriespages/womenscategory.dart';
import 'package:relt/Screen/search.dart';

class Maincategory extends StatefulWidget {
  const Maincategory({super.key});

  @override
  MaincategoryState createState() => MaincategoryState();
}

class MaincategoryState extends State<Maincategory> {
  bool _womenSelected = true;
  bool _menSelected = false;
  List<String> womenContainers = ['New', 'Tops', 'Pants', 'Others Accessories'];
  List<String> menContainers = ['New', 'Shirts', 'Pants', 'Others Accessories'];

  void _selectWomen() {
    setState(() {
      _womenSelected = true;
      _menSelected = false;
    });
  }

  void _selectMen() {
    setState(() {
      _menSelected = true;
      _womenSelected = false;
    });
  }

  void _navigateToCategoryPage(String categoryName) {
    if (_womenSelected) {
      switch (categoryName) {
        case 'New':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WomenNewPage()),
          );
          break;
        case 'Tops':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WomenTopsPage()),
          );
          break;
        case 'Pants':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WomenPantsPage()),
          );
          break;
        case 'Others Accessories':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WomenAccessoriesPage()),
          );
          break;
        default:
          // Handle unknown category
          break;
      }
    } else if (_menSelected) {
      switch (categoryName) {
        case 'New':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenNewPage()),
          );
          break;
        case 'Shirts':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenShirtsPage()),
          );
          break;
        case 'Pants':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenPantsPage()),
          );
          break;
        case 'Others Accessories':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenAccessoriesPage()),
          );
          break;
        default:
          // Handle unknown category
          break;
      }
    }
  }

  void navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search()), // Navigate to Search screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CATEGORIES ",textAlign: TextAlign.center ,),backgroundColor: Colors.black,
       actions: [
          IconButton(
            onPressed: navigateToSearch, // Call the navigateToSearch function
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _selectWomen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _womenSelected ? Colors.blue : Colors.grey,
                ),
                child: const Text('Women'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _selectMen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _menSelected ? Colors.blue : Colors.grey,
                ),
                child: const Text('Men'),
              ),
            ],
          ),
          Expanded(
            child: _womenSelected
                ? WomenSectionPage(
                    containers: womenContainers,
                    onNavigateToCategoryPage: _navigateToCategoryPage,
                  )
                : MenSectionPage(
                    containers: menContainers,
                    onNavigateToCategoryPage: _navigateToCategoryPage,
                  ),
          ),
        ],
      ),
     
    );
  }
}

class WomenSectionPage extends StatefulWidget {
  final List<String> containers;
  final Function(String) onNavigateToCategoryPage;

  const WomenSectionPage({super.key, 
    required this.containers,
    required this.onNavigateToCategoryPage,
  });

  @override
  State<WomenSectionPage> createState() => _WomenSectionPageState();
}

class _WomenSectionPageState extends State<WomenSectionPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.containers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final containerName = widget.containers[index];
        return ListTile(
          title: Text(containerName),
          onTap: () {
            widget.onNavigateToCategoryPage(containerName);
            
            
          },
        );
      },
    );
  }
}

class MenSectionPage extends StatefulWidget {
  final List<String> containers;
  final Function(String) onNavigateToCategoryPage;

  const MenSectionPage({super.key, 
    required this.containers,
    required this.onNavigateToCategoryPage,
  });

  @override
  State<MenSectionPage> createState() => _MenSectionPageState();
}

class _MenSectionPageState extends State<MenSectionPage> {
  @override
  Widget build(BuildContext context) {
    
    return ListView.separated(
      itemCount: widget.containers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final containerName = widget.containers[index];
        return ListTile(
          title: Text(containerName),
          onTap: () {
            widget.onNavigateToCategoryPage(containerName);
          },
        );
      },
    );
  }
}





