import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management/models/company_model.dart';
import 'package:inventory_management/services/db_services.dart';
import 'package:inventory_management/utils/constants.dart';
import 'package:inventory_management/utils/snackbar.dart';
import 'package:inventory_management/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _companyInviteCode = TextEditingController();
  TextEditingController _relatedCompanyCode = TextEditingController();

  UserModel? user;
  Future<UserModel> getUser() async {
    UserModel _user = await DbServices().getCurrentUser();
    setState(() {
      user = _user;
    });
    return user!;
  }

  Uint8List? _image;

  getImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _relatedCompanyCode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<UserModel>(
      future: DbServices().getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        UserModel user = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.email),
              Text(user.name),
              Text(user.surName),
              InkWell(
                onTap: () {
                  getImage();
                },
                child: _image == null
                    ? Image.network(
                        user.companyOfUser.companyImageUrl,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      )
                    : Image(
                        image: MemoryImage(_image!),
                      ),
              ),
              user.companyOfUser.companyName == 'defaultCompanyName'
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              controller: _companyNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Company name',
                              ),
                            )),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            CompanyModel company = CompanyModel(
                              companyImageUrl: defaultCompanyPhoto,
                              companyName: _companyNameController.text.trim(),
                              companyId: const Uuid().v4(),
                            );
                            DbServices().createCompany(
                              user,
                              company,
                              _image,
                            );
                          },
                          child: Text('Create company'),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              controller: _companyInviteCode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Join company with invite code ',
                              ),
                            )),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            DbServices().signInCompanyWithCode(
                                user, _companyInviteCode.text);
                          },
                          child: Text('Join company with invite code'),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(user.companyOfUser.companyName),
                        ElevatedButton(
                          onPressed: () {
                            DbServices().quitTheCompany(user);
                          },
                          child: Text('Quit the company'),
                        ),
                        SelectableText(user.companyOfUser.companyId),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormField(
                                  controller: _relatedCompanyCode,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Add the related company',
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                String res = await DbServices()
                                    .addRelatedCompany(
                                        _relatedCompanyCode.text, user);
                                if (res == 'success') {
                                  showSnackBar('Firma eklendi', context);
                                } else {
                                  showSnackBar(res, context);
                                }
                              },
                              child: Text('Add the related company'),
                            ),
                          ],
                        ),
                      ],
                    ),
              Text('İş ortakligi yaptiginiz firmalar : '),
              Column(
                children: [
                  StreamBuilder<List<CompanyModel>>(
                    stream: DbServices().getRelatedCompaniesStream(user),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.isEmpty) {
                        return Text('İş ortağı firma yok');
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      List<CompanyModel> allRelatedCompanies = snapshot.data!;
                      return ListView.builder(
                        itemCount: allRelatedCompanies.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          CompanyModel relatedCompany =
                              allRelatedCompanies[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(relatedCompany.companyImageUrl),
                            ),
                            title: Text(relatedCompany.companyName),
                          );
                        },
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    ));
  }
}
