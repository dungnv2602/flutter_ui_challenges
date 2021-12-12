/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.alarm, color: Colors.black),
            Icon(Icons.search, color: Colors.red),
            InkWell(
              onTap: () {},
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.5),
                    offset: Offset(0, 8),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ]),
                child: RawMaterialButton(
                  onPressed: () {},
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
            Icon(Icons.notifications_none, color: Colors.black),
            Icon(Icons.tab, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
