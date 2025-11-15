import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../colors.dart';
import '../../components/dashboard/home/workshop_image_swiper.dart';
import '../../components/dashboard/home/workshop_info_section.dart';
import '../../components/dashboard/home/workshop_description_tab.dart';
import '../../components/dashboard/home/workshop_masters_tab.dart';
import '../../components/dashboard/home/workshop_services_tab.dart';

class WorkshopDetailPage extends StatefulWidget {
  final String workshopName;
  final String address;
  final String workingHours;
  final String phone;
  final List<Map<String, String>> services;

  const WorkshopDetailPage({
    super.key,
    required this.workshopName,
    required this.address,
    required this.workingHours,
    required this.phone,
    required this.services,
  });

  @override
  State<WorkshopDetailPage> createState() => _WorkshopDetailPageState();
}

class _WorkshopDetailPageState extends State<WorkshopDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.workshopName,
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Manrope',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/map.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Handle map tap
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/share.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Handle share tap
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Swiper
                  const WorkshopImageSwiper(),
                  // Workshop Info
                  WorkshopInfoSection(
                    workshopName: widget.workshopName,
                    address: widget.address,
                    workingHours: widget.workingHours,
                    phone: widget.phone,
                  ),
                  // Tabs
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.orange,
                    indicatorWeight: 2,
                    labelColor: AppColors.orange,
                    unselectedLabelColor: isDark
                        ? AppColors.textGreyLight
                        : AppColors.lightTextSecondary,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Manrope',
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Manrope',
                    ),
                    tabs: const [
                      Tab(text: 'Описание'),
                      Tab(text: 'Мастера'),
                      Tab(text: 'Услуги'),
                    ],
                  ),
                  // Tab Content
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Description Tab
                        const WorkshopDescriptionTab(),
                        // Masters Tab
                        const WorkshopMastersTab(),
                        // Services Tab
                        WorkshopServicesTab(services: widget.services),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Button
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30,top:10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: InkWell(
                onTap: () {
                  // Handle leave request
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: const [
                        AppColors.orangeGradientStart,
                        AppColors.orangeGradientEnd,
                      ],
                      stops: const [0.0, 1.0],
                      transform: GradientRotation(80.32 * 3.14159 / 180),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.orangeLight,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orangeGradientShadow.withOpacity(0.2),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Оставить заявку',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }

}

