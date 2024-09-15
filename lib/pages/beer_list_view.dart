import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lagu_daerah_app/data/models/lagu_response_model.dart';
import 'package:flutter_lagu_daerah_app/pages/add_lagu_page.dart';
import 'package:flutter_lagu_daerah_app/pages/lagu_detail_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_lagu_daerah_app/data/datasource/lagu_remote_datasource.dart';

class BeerListView extends StatefulWidget {
  const BeerListView({super.key});

  @override
  _BeerListViewState createState() => _BeerListViewState();
}

class _BeerListViewState extends State<BeerListView> {
  final PagingController<int, Lagu> _pagingController =
      PagingController(firstPageKey: 1);

  final TextEditingController judulController = TextEditingController();
  final TextEditingController laguController = TextEditingController();
  final TextEditingController daerahController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();

  XFile? image;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await LaguRemoteDataSource().getLaguDaerahPages(pageKey);

      final isLastPage = newItems.data.currentPage == newItems.data.lastPage;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data.data);
      } else {
        _pagingController.appendPage(newItems.data.data, ++pageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _refreshPage() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lagu Daerah',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blueGrey,
      ),
      body: PagedListView<int, Lagu>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Lagu>(
          itemBuilder: (context, item, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LaguDetailPage(lagu: item);
                    },
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          '${LaguRemoteDataSource.imageUrl}/${item.imageUrl}',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.judul,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(item.daerah),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8), // Space between buttons
                      Row(
                        children: [
                          // Space between buttons
                          IconButton(
                            onPressed: () {
                              judulController.text = item.judul;
                              laguController.text = item.lagu;
                              daerahController.text = item.daerah;
                              videoUrlController.text = item.videoUrl;
                              image = null;

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text('Edit Lagu'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Judul',
                                                ),
                                                controller: judulController,
                                              ),
                                              const SizedBox(height: 10),
                                              TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Lagu',
                                                ),
                                                maxLines: 4,
                                                controller: laguController,
                                              ),
                                              const SizedBox(height: 10),
                                              TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Daerah',
                                                ),
                                                controller: daerahController,
                                              ),
                                              const SizedBox(height: 10),
                                              TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Video Url',
                                                ),
                                                controller: videoUrlController,
                                              ),
                                              const SizedBox(height: 12),
                                              item.imageUrl != null &&
                                                      image == null
                                                  ? SizedBox(
                                                      height: 80,
                                                      child: Image.network(
                                                        '${LaguRemoteDataSource.imageUrl}/${item.imageUrl}',
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              image != null
                                                  ? SizedBox(
                                                      height: 80,
                                                      child: Image.file(
                                                        File(image!.path),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      final ImagePicker picker =
                                                          ImagePicker();
                                                      image = await picker
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                      setState(() {});
                                                    },
                                                    child: const Text(
                                                        'Upload Gambar'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              XFile? imageToUpload = image;

                                              try {
                                                await LaguRemoteDataSource()
                                                    .updateLaguDaerah(
                                                  item.id,
                                                  judulController.text,
                                                  laguController.text,
                                                  daerahController.text,
                                                  videoUrlController.text,
                                                  imageToUpload,
                                                );

                                                judulController.clear();
                                                laguController.clear();
                                                daerahController.clear();
                                                videoUrlController.clear();
                                                image = null;

                                                _refreshPage();
                                                Navigator.of(context).pop();
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Gagal mengupdate data: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text('Update'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit),
                            iconSize: 20,
                            padding: const EdgeInsets.all(10),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Lagu'),
                                    content: Text(
                                        'Apakah anda yakin menghapus lagu ${item.judul}?'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Tidak'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await LaguRemoteDataSource()
                                              .deleteLaguDaerah(item.id);
                                          _refreshPage();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ya'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete),
                            iconSize: 20,
                            padding: const EdgeInsets.all(0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AddLaguPage();
              },
            ),
          );
          await _refreshPage();
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
