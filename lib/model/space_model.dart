class SpacesList {
  final int id;
  final String image;
  final String spaceName;
  final int deviceNo;
  final Map deviceData;

  SpacesList({
    required this.deviceData,
    required this.id,
    required this.image,
    required this.spaceName,
    required this.deviceNo,
  });
}

List<SpacesList> spaceList = [
  SpacesList(
      id: 1,
      image: "assets/images/room1.jpg",
      spaceName: "Living Room",
      deviceNo: 5,
      deviceData: {}),
  SpacesList(
    deviceData: {},
    id: 2,
    image: "assets/images/room2.jpg",
    spaceName: "BedRoom",
    deviceNo: 3,
  ),
  SpacesList(
    deviceData: {},
    id: 2,
    image: "assets/images/room3.jpg",
    spaceName: "Kitchen",
    deviceNo: 3,
  ),
  SpacesList(
    deviceData: {},
    id: 2,
    image: "assets/images/room4.jpg",
    spaceName: "Balcony",
    deviceNo: 3,
  ),
];
