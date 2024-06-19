import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComicReader extends StatefulWidget {
  final List<String> links;
  final String name;

  const ComicReader(this.links, this.name);

  @override
  State<ComicReader> createState() => _ComicReaderState();
}

class _ComicReaderState extends State<ComicReader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name,
            softWrap: true,
            style: TextStyle(fontSize: 14),
          ),
        ),
        body: widget.links != null
            ? SizedBox(
                height: MediaQuery.of(context).size.height - 20,
                child: PageView.builder(
                  itemBuilder: (context, count) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.links[count],
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    );
                  },
                  itemCount: widget.links.length - 1,
                ),
              )
            : Center(
                child: Text('Comming soon'),
              ));
  }
}
