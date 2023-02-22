import 'dart:io';

import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/date_picker.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BingoModal extends StatelessWidget {
  const BingoModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Text('bingo!'),
    );
  }
}

class DateModal extends StatelessWidget {
  const DateModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(child: DatePicker());
  }
}

class ImageModal extends StatelessWidget {
  const ImageModal({super.key});

  @override
  Widget build(BuildContext context) {
    XFile? selectImage;
    void imagePicker() async {
      final ImagePicker picker = ImagePicker();
      selectImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 100,
        maxWidth: 100,
        imageQuality: 50,
      );
    }

    return SimpleDialog(
      title: Column(
        children: [
          const CustomText(content: '그룹 이미지 선택', fontSize: FontSize.largeSize),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(),
                  image: selectImage != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(
                            File(selectImage!.path),
                          ))
                      : null),
              width: 100,
              height: 100,
              child: selectImage == null
                  ? CustomIconButton(
                      icon: addIcon,
                      onPressed: imagePicker,
                    )
                  : null,
            ),
          ),
          const ExitButton(isIconType: false)
        ],
      ),
    );
  }
}
