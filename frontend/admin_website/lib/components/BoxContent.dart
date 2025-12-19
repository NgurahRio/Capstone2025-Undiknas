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
  final VoidCallback onTap;

  const BoxImageContent({
    super.key,
    required this.images,
    required this.delete,
    required this.onTap,
  });

  @override
  State<BoxImageContent> createState() => _BoxImageContentState();
}

class _BoxImageContentState extends State<BoxImageContent> {
  bool isHover = false;
  late List<bool> hoverDelete;

  @override
  void initState() {
    super.initState();
    hoverDelete = List.generate(widget.images.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (hoverDelete.length != widget.images.length) {
      hoverDelete = List.generate(widget.images.length, (_) => false);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: widget.images.isEmpty
              ? EdgeInsets.zero
              : const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isHover ? const Color(0xFFC9CED5) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isHover ? Colors.black : Colors.grey,
              width: 0.6,
            ),
          ),
          child: Stack(
            children: [
              widget.images.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Wrap(
                        spacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: const [
                          Icon(
                            Icons.file_upload_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                          Text(
                            "Upload",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                  )
                  : SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.images.length,
                        itemBuilder: (context, index) {
                          return MouseRegion(
                            onEnter: (_) =>
                                setState(() => hoverDelete[index] = true),
                            onExit: (_) =>
                                setState(() => hoverDelete[index] = false),
                            child: Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          MemoryImage(widget.images[index]!),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () => widget.delete(index),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 120),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: hoverDelete[index]
                                            ? const Color(0xFFE06666)
                                            : const Color(0xFFFF8484),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

              if (isHover)
                Positioned.fill(
                  child: IgnorePointer(
                    child: widget.images.isNotEmpty
                      ? Center(
                          child: Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: const [
                              Icon(
                                Icons.file_upload_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                              Text(
                                "Upload",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


class BoxTextContent extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback? onTap;

  const BoxTextContent({
    super.key,
    required this.controller,
    required this.label,
    this.onTap,
  });

  @override
  State<BoxTextContent> createState() => _BoxTextContentState();
}

class _BoxTextContentState extends State<BoxTextContent> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (context, value, _) {
        final text = value.text.trim();
        final isEmpty = text.isEmpty;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHover = true),
          onExit: (_) => setState(() => isHover = false),
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: isHover && widget.onTap != null ? const Color(0xFFC9CED5) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isHover && widget.onTap != null ? Colors.black : Colors.black54,
                  width: 0.5,
                ),
              ),
              child: Stack(
                children: [
                  Expanded(
                    child: Text(
                      isEmpty ? widget.label : text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: isEmpty ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ),

                  if (isHover && widget.onTap != null)
                    Positioned.fill(
                      child: Center(
                          child: Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: const [
                              Icon(
                                Icons.access_time,
                                color: Colors.black,
                                size: 20,
                              ),
                              Text(
                                "Clock",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        )
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}



