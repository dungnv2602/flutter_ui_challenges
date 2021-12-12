// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Raw data for the animation demo.

import 'package:flutter/material.dart';

const Color _mariner = Color(0xFF3B5F8F);
const Color _purple = Color(0xFF8266D4);
const Color _tomato = Color(0xFFF95B57);
const Color _orange = Color(0xFFF3A646);

const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

@immutable
class SectionDetailItem {
  const SectionDetailItem({
    this.title,
    this.subtitle,
    this.imageAsset,
    this.imageAssetPackage,
  });
  final String title;
  final String subtitle;
  final String imageAsset;
  final String imageAssetPackage;

  @override
  bool operator ==(Object other) {
    return other is SectionDetailItem &&
        other.title == title &&
        other.imageAsset == imageAsset &&
        other.imageAssetPackage == imageAssetPackage;
  }

  @override
  int get hashCode => title.hashCode + imageAsset.hashCode + imageAssetPackage.hashCode;
}

@immutable
class Section {
  const Section({
    this.title,
    this.backgroundAsset,
    this.backgroundAssetPackage,
    this.leftColor,
    this.rightColor,
    this.details,
  });
  final String title;
  final String backgroundAsset;
  final String backgroundAssetPackage;
  final Color leftColor;
  final Color rightColor;
  final List<SectionDetailItem> details;

  @override
  bool operator ==(Object other) {
    return other is Section &&
        other.title == title &&
        other.backgroundAsset == backgroundAsset &&
        other.backgroundAssetPackage == backgroundAssetPackage;
  }

  @override
  int get hashCode => title.hashCode + backgroundAsset.hashCode + backgroundAssetPackage.hashCode;
}

const SectionDetailItem _eyeglassesDetail = SectionDetailItem(
  imageAsset: 'products/sunnies.png',
  imageAssetPackage: _kGalleryAssetsPackage,
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetailItem _seatingDetail = SectionDetailItem(
  imageAsset: 'products/table.png',
  imageAssetPackage: _kGalleryAssetsPackage,
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetailItem _decorationDetail = SectionDetailItem(
  imageAsset: 'products/earrings.png',
  imageAssetPackage: _kGalleryAssetsPackage,
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetailItem _protectionDetail = SectionDetailItem(
  imageAsset: 'products/hat.png',
  imageAssetPackage: _kGalleryAssetsPackage,
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const List<Section> allSections = <Section>[
  Section(
    title: 'SUNGLASSES',
    leftColor: _purple,
    rightColor: _mariner,
    backgroundAsset: 'products/sunnies.png',
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: <SectionDetailItem>[
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
    ],
  ),
  Section(
    title: 'FURNITURE',
    leftColor: _tomato,
    rightColor: _purple,
    backgroundAsset: 'products/table.png',
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: <SectionDetailItem>[
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
    ],
  ),
  Section(
    title: 'JEWELRY',
    leftColor: _orange,
    rightColor: _tomato,
    backgroundAsset: 'products/earrings.png',
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: <SectionDetailItem>[
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
    ],
  ),
  Section(
    title: 'HEADWEAR',
    leftColor: Colors.white,
    rightColor: _tomato,
    backgroundAsset: 'products/hat.png',
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: <SectionDetailItem>[
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
    ],
  ),
];
