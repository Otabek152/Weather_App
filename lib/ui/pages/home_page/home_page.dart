import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/components/current_weather_status.dart';
import 'package:weather_app/ui/components/grid_items.dart';
import 'package:weather_app/ui/components/max_min_temprature.dart';
import 'package:weather_app/ui/components/sunrise_sunset_widget.dart';
import 'package:weather_app/ui/components/weekday_widget.dart';
import 'package:weather_app/ui/routes/app_routes.dart';
import 'package:weather_app/ui/theme/app_colors.dart';
import 'package:weather_app/ui/theme/app_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.watch<WeatherProvider>().setUp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const HomePageWidget();
          } else {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 50,
                color: Colors.red,
              ),
            );
          }
        });
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextButton.icon(
          onPressed: () {},
          icon: Icon(
            Icons.location_on_rounded,
            color: AppColors.redColor,
          ),
          label: Text(
            'Ташкент',
            style: AppStyle.fontStyle,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.go(AppRoutes.search);
            },
            icon: Icon(
              Icons.add,
              color: AppColors.darkBlue,
            ),
          ),
        ],
        bottom: const BottomAppBar(),
      ),
      body: const HomeBody(),
    );
  }
}

class BottomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BottomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return Text(
      '${model.date.last} ${model.currentTime}',
      style: AppStyle.fontStyle.copyWith(
        fontSize: 14,
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 10);
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherView = context.watch<WeatherProvider>();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            weatherView.setBg(),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 36, left: 16, right: 16),
        child: ListView(
          children: [
            const CurrentWeatherStatus(),
            const SizedBox(height: 10),
            //alt + 0176 = °
            Text(
              '${weatherView.currentTemp}℃',
              textAlign: TextAlign.center,
              style: AppStyle.fontStyle.copyWith(fontSize: 90),
            ),
            const SizedBox(height: 18),
            const MaxMinTemprature(),
            const SizedBox(height: 40),
            const WeekDayWidget(),
            const SizedBox(height: 27),
            const GridItems(),
            const SizedBox(height: 30),
            const SunRiseSunSetWidget(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}























// Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             context.go(AppRoutes.search);
//           },
//           icon: const Icon(Icons.next_plan),
//         ),
//       ),
//     );