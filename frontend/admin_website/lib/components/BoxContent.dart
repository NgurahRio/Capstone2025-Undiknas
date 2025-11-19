import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class BoxAddContent extends StatefulWidget {
  final List<String> items;
  final Function(int) delete;
  final List<Object?>? images;

  const BoxAddContent({
    super.key,
    required this.items,
    this.images,
    required this.delete,
  });

  @override
  State<BoxAddContent> createState() => _BoxAddContentState();
}

class _BoxAddContentState extends State<BoxAddContent> {
  late List<bool> hoverDelete;

  bool isBase64(String data) {
    try {
      base64Decode(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    hoverDelete = List.generate(widget.items.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {

    if (hoverDelete.length != widget.items.length) {
      hoverDelete = List.generate(widget.items.length, (_) => false);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.black54,
            width: 0.5,
          ),
        ),
        child: Column(
          children: List.generate(widget.items.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (widget.images != null)
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                          child: (() {
                            final img = widget.images![index];

                            if (img == null) {
                              return const Icon(Icons.image_not_supported);
                            }

                            if (img is Uint8List) {
                              return Image.memory(img, fit: BoxFit.cover);
                            }

                            if (img is String) {
                              if (isBase64(img)) {
                                return Image.memory(
                                  base64Decode(img),
                                );
                              } else {
                                return Image.asset(img, fit: BoxFit.cover);
                              }
                            }
                          })(),
                        ),

                      Text(
                        widget.items[index],
                        style: const TextStyle(
                          color: Color(0xFF6189AF),
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                    ],
                  ),

                  MouseRegion(
                    onEnter: (_) {
                      setState(() => hoverDelete[index] = true);
                    },
                    onExit: (_) {
                      setState(() => hoverDelete[index] = false);
                    },
                    child: GestureDetector(
                      onTap: () => widget.delete(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: hoverDelete[index]
                              ? const Color(0xFFE06666)
                              : const Color(0xFFFF8484),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}


class BoxImageContent extends StatefulWidget {
  final List<Uint8List?> images;
  final Function(int) delete;

  const BoxImageContent({
    super.key,
    required this.images,
    required this.delete,
  });

  @override
  State<BoxImageContent> createState() => _BoxImageContentState();
}

class _BoxImageContentState extends State<BoxImageContent> {
  late List<bool> hoverDeleteImage;

  @override
  void initState() {
    super.initState();
    hoverDeleteImage = List.generate(widget.images.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (hoverDeleteImage.length != widget.images.length) {
      hoverDeleteImage = List.generate(widget.images.length, (_) => false);
    }

    return Expanded(
      child: Container(
        padding: widget.images.isEmpty 
          ? EdgeInsets.symmetric(horizontal: 15, vertical: 10)
          : EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black54, width: 0.5)
        ),
        child: widget.images.isEmpty
          ? Text(
              "Choose File",
              style: TextStyle(color: Colors.grey),
            )
          : SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(widget.images[index]!)
                          )
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: MouseRegion(
                          onEnter: (_) {
                            setState(() => hoverDeleteImage[index] = true);
                          },
                          onExit: (_) {
                            setState(() => hoverDeleteImage[index] = false);
                          },
                          child: GestureDetector(
                            onTap: () => widget.delete(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                color: hoverDeleteImage[index]
                                    ? const Color(0xFFE06666)
                                    : const Color(0xFFFF8484),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.close, 
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
      )
    );
  }
}
