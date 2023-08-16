import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BacheadView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bachead con el listado de usuarios y lugares turísticos',
          style: TextStyle(fontFamily: 'georgia', fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/imgs/TriptekkerLogo.jpg',
              height: 150,
            ),
          ),
          Expanded(
            child: UserList(),
          ),
          SizedBox(height: 20),
          Text(
            'Lugares Turísticos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TouristPlacesList(),
        ],
      ),
    );
  }
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error al obtener usuarios');
        }
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<UserListItem> userItems = snapshot.data!.docs.map((doc) {
          String username = doc.get('username');
          String? photoURL = doc.get('profilePictureUrl');
          return UserListItem(username: username, photoURL: photoURL);
        }).toList();

        return ListView(
          children: userItems,
        );
      },
    );
  }
}

class UserListItem extends StatelessWidget {
  final String username;
  final String? photoURL;

  UserListItem({required this.username, this.photoURL});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: photoURL != null
          ? CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(photoURL!),
            )
          : CircleAvatar(
              radius: 25,
              child: Icon(Icons.person),
            ),
      title: Text(username),
    );
  }
}

class TouristPlacesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(touristPlaces.length, (index) {
            return TouristPlaceCard(
              placeName: touristPlaces[index]['name'],
              imageUrl: touristPlaces[index]['imageUrl'],
            );
          }),
        ),
      ),
    );
  }
}

class TouristPlaceCard extends StatelessWidget {
  final String placeName;
  final String imageUrl;

  TouristPlaceCard({required this.placeName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          SizedBox(height: 8),
          Text(placeName),
        ],
      ),
    );
  }
}

// Lista de lugares turisticos.
List<Map<String, dynamic>> touristPlaces = [
  {
    'name': 'HardRock Punta Cana',
    'imageUrl': 'https://images1.bovpg.net/r/back/es/sale/b6f1e255f3810a.jpg',
  },
  {
    'name': 'Museo Nacional del Prado en Madrid',
    'imageUrl':
        'https://prensaygente.com/wp-content/uploads/2022/09/museo-nacional-del-prado.jpg',
  },
  {
    'name': 'Palacio de Versalles en Francia',
    'imageUrl':
        'https://www.eluniversal.com.mx/resizer/B8V69tna68-M01ll_JTnpsZkR1c=/1100x666/cloudfront-us-east-1.images.arcpublishing.com/eluniversal/XYMAQXIUHZEX3IQ4GLLAJPNU2Q.jpg',
  },

  {
    'name': 'Coliseo Romano en Roma',
    'imageUrl':
        'https://www.enroma.com/wp-content/uploads/elementor/thumbs/Coliseo-Romano-p9hfybrrriyw7zyeoat3i5xq91dbuq09smp8uhsmrk.jpg',
  },
  {
    'name': 'Parques de Walt Disney World, Orlando',
    'imageUrl':
        'https://www.purosviajes.com/wp-content/uploads/2022/02/disney.jpg',
  },
  {
    'name': 'Monte Fuji, Japon',
    'imageUrl':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Chuurei-tou_Fujiyoshida_17025277650_c59733d6ba_o.jpg/1200px-Chuurei-tou_Fujiyoshida_17025277650_c59733d6ba_o.jpg',
  },

  {
    'name': 'Basílica de la Sagrada Família en Barcelona.',
    'imageUrl':
        'https://cdn-imgix.headout.com/mircobrands-content/image/0cc05cc8a1337b89ef07e295afb195db-Sagrada%20Familia.jpg',
  },
  {
    'name': 'Zermatt, Suiza',
    'imageUrl':
        'https://content.skyscnr.com/m/09806e8565ca75de/original/GettyImages-467335200.jpg?resize=1800px:1800px&quality=100',
  },
  {
    'name': 'Playa Rincon, RD',
    'imageUrl':
        'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/27/19/17/35/caption.jpg?w=300&h=300&s=1',
  },
  {
    'name': 'Zona Colonial, Santo Domingo RD',
    'imageUrl':
        'https://content.r9cdn.net/rimg/dimg/f2/36/1fbe7a3d-hood-216602-169d9893ee2.jpg?width=1366&height=768&xhint=1327&yhint=1439&crop=true',
  },
  // Anadir mas lugares
];
