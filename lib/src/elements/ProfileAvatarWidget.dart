import 'package:cached_network_image/cached_network_image.dart';
import 'package:deliveryboy/src/models/user.dart';
import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final User user;

  ProfileAvatarWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                user.image != null && user.image!.url != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(300)),
                        child: CachedNetworkImage(
                          height: 135,
                          width: 135,
                          fit: BoxFit.cover,
                          imageUrl: user.image!.url!,
                          placeholder: (context, url) => Image.asset('assets/img/loading.gif', fit: BoxFit.cover, height: 135, width: 135),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(300)),
                        child: CircleAvatar(radius: 65, child: Icon(Icons.person, size: 90, color: Theme.of(context).primaryColor)),
                      )
              ],
            ),
          ),
          user.name != null
              ? Text(user.name!, style: Theme.of(context).textTheme.headlineSmall?.merge(TextStyle(color: Theme.of(context).primaryColor)))
              : SizedBox(),
          user.address != null
              ? Text(user.address!, style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Theme.of(context).primaryColor)))
              : SizedBox(),
        ],
      ),
    );
  }
}
