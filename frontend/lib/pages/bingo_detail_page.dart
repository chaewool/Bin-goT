import 'package:flutter/material.dart';

class BingoDetail extends StatelessWidget {
  const BingoDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'appBar',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'title',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'nickname',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.edit),
                Icon(Icons.delete),
              ],
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.amber),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 100,
                  horizontal: 100,
                ),
                child: Text(
                  'bingo',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'achieve',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.amber),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.home,
                      size: 30,
                    ),
                    Icon(
                      Icons.person,
                      size: 30,
                    ),
                    Icon(
                      Icons.chat,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
