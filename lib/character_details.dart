import 'package:flutter/material.dart';
import 'package:rick_and_morty/response_model.dart';

import 'DeviceTypeAndOrientation.dart';

class CharacterDetails extends StatelessWidget {
  const CharacterDetails(this.character, {super.key});

  final Character character;

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceTypeAndOrientation(context);

    final size = MediaQuery.of(context).size;

    if (deviceType == DeviceType.tabletLandscape ||
        deviceType == DeviceType.phoneLandscape) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: size.width * 0.3,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow('Species', character.species ?? '', deviceType),
                      _infoRow(
                          'Origin', character.origin?.name ?? '', deviceType),
                      _infoRow('Gender', character.gender ?? '', deviceType),
                      _infoRow('Status', character.status ?? '', deviceType),
                      _infoRow('Location', character.location?.name ?? '',
                          deviceType),
                    ]),
              ),
            ),
            SizedBox(
              width: size.width * 0.3,
              child: Image.network(character.image ?? '', fit: BoxFit.cover),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: deviceType == DeviceType.tabletPortrait
            ? size.width * 0.8
            : size.width,
        padding: EdgeInsets.all(deviceType == DeviceType.tabletPortrait ||
                deviceType == DeviceType.phonePortrait
            ? 20
            : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (deviceType == DeviceType.tabletPortrait ||
                deviceType == DeviceType.phonePortrait)
              Text(
                character.name ?? '',
                style: TextStyle(
                    fontSize: deviceType == DeviceType.tabletPortrait ||
                            deviceType == DeviceType.phonePortrait
                        ? 25
                        : 19),
              ),
            SizedBox(height: 8),
            Image.network(character.image ?? '',
                fit: BoxFit.fill,
                width: deviceType == DeviceType.phonePortrait
                    ? 300
                    : double.infinity),
            _infoRow('Species', character.species ?? '', deviceType),
            _infoRow('Origin', character.origin?.name ?? '', deviceType),
            _infoRow('Gender', character.gender ?? '', deviceType),
            _infoRow('Status', character.status ?? '', deviceType),
            _infoRow('Location', character.location?.name ?? '', deviceType),
          ],
        ),
      );
    }
  }

  Widget _infoRow(String title, String info, DeviceType deviceType) {
    final isLargeText = deviceType == DeviceType.tabletLandscape ||
        deviceType == DeviceType.phonePortrait ||
        deviceType == DeviceType.tabletPortrait;

    return Padding(
      padding: EdgeInsets.only(top: isLargeText ? 24.0 : 20),
      child: Row(
        children: [
          Text('$title:   ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18)),
          Expanded(
            child: Text(
              info,
              style: TextStyle(fontSize: isLargeText ? 19 : 17),
            ),
          )
        ],
      ),
    );
  }
}
