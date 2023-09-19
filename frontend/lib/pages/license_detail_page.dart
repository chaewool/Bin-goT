//* 라이선스 세부 내용
import 'package:bin_got/oss_licenses.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class LicenseDetailPage extends StatelessWidget {
  final Package package;

  const LicenseDetailPage({super.key, required this.package});

  String bodyText() {
    return package.license!.split('\n').map((line) {
      if (line.startsWith('//')) line = line.substring(2);
      line = line.trim();
      return line;
    }).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBack(),
      body: CustomBoxContainer(
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: CustomText(
                  content: '${package.name} ${package.version}',
                  fontSize: FontSize.largeSize,
                  bold: true,
                ),
              ),
              if (package.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CustomText(
                    content: package.description,
                    height: 1.2,
                  ),
                ),
              if (package.homepage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    child: CustomText(
                      content: package.homepage!,
                      color: blueColor,
                      height: 1.2,
                      // style: const TextStyle(
                      //     color: Colors.blue,
                      //     decoration: TextDecoration.underline)
                    ),
                    onTap: () {},

                    // => launch(package.homepage!),
                  ),
                ),
              if (package.description.isNotEmpty || package.homepage != null)
                const CustomDivider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: CustomText(
                  content: bodyText(),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
