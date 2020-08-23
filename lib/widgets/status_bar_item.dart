import 'package:chatapp/pages/home/story_view_page.dart';
import 'package:chatapp/services/friends_service.dart';
import 'package:flutter/material.dart';

class StatusBarItem extends StatefulWidget 
{
  // the name of the user
  final String _id;

  StatusBarItem(this._id);
  @override
  _StatusBarItemState createState() => _StatusBarItemState();
}

class _StatusBarItemState extends State<StatusBarItem> 
{
  String _imageRef;
  String _username;
  bool _watched = false;

  @override
  void initState()
  {
    super.initState();
    init();
  }

  void init()
  {
    FriendsService.loadImage(widget._id).then((value)
    {
      setState(() {
        _imageRef = value;
      });
    });

    FriendsService.getUsernameForId(widget._id).then((value) 
    { 
      setState(() {
        _username = value;
      });
    });
  }

  /// get CircualarAvatar which contains the users profile image
  Widget getCircularAvatar()
  {
    return GestureDetector(
      onTap: () 
      {
        setState(() {
          _watched = true;
        });
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StoryViewPage(widget._id, _username) 
        ));
      },
      child: Hero(
        tag: _username != null ? 'storyimage' + _username : "",
        child: CircleAvatar(
          radius: 25,
          backgroundImage: _imageRef != null ? NetworkImage(
            _imageRef
          ) : AssetImage("assets/logo.png"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal : 5),
      child: Container(
        width: 55,
        child: Column(
          children: <Widget>[
            _watched ? getCircularAvatar()
            : Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    width: 2
                  )
                ),
                child: getCircularAvatar()
              ),
            Padding(
              padding: const EdgeInsets.only(top:5),
              child: Hero(
                tag: _username != null ? 'story' + _username : "",
                child: Text(
                  _username != null ?_username : "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.w600, 
                    color: Colors.black
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
