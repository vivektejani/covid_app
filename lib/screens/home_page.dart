import 'package:covid_app/helper/covid_api_helper.dart';
import 'package:covid_app/models/covid.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic selectedCountry;
  List country = [];
  List flag = [];
  dynamic i;
  TextStyle mystyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.8),
      appBar: AppBar(
        title: const Text("Covid-19 Case Tracker"),
        elevation: 1,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 20,
                top: 8,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FutureBuilder(
                future: CovidApiHelper.covidApiHelper.fetchCovidData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error : ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    List<CovidData> data = snapshot.data as List<CovidData>;
                    country = data.map((e) => e.name).toList();
                    return Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: DropdownButtonFormField(
                                iconSize: 35,
                                icon: const Icon(Icons.location_on_outlined),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.blue.withOpacity(0.1),
                                ),
                                hint: const Text("Select Country"),
                                value: selectedCountry,
                                onChanged: (val) {
                                  setState(() {
                                    selectedCountry = val;
                                    i = country.indexOf(val);
                                  });
                                },
                                items: country.map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      child: Text(e),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            (i != null)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      Card(
                                        elevation: 10,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                height: 130,
                                                width: double.infinity,
                                                child: Image.network(
                                                  data[i].flag,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Text(
                                                "${data[i].name}",
                                                style: mystyle,
                                              ),
                                              Text(
                                                "Population: ${data[i].Population}",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      builcard(
                                          title: "Confirmed",
                                          totalCount: data[i].totalConfirmed,
                                          todayCount: data[i].todayConfirmed,
                                          color: Colors.red),
                                      builcard(
                                          title: "Recovered",
                                          totalCount: data[i].totalRecovered,
                                          todayCount: data[i].todayRecovered,
                                          color: Colors.green),
                                      builcard(
                                          title: "Deaths",
                                          totalCount: data[i].totalDeaths,
                                          todayCount: data[i].todayDeaths,
                                          color: Colors.blueGrey),
                                      builcard(
                                          title: "Active",
                                          totalCount: data[i].totalActive,
                                          todayCount: "",
                                          color: Colors.blue),
                                      builcard(
                                          title: "Critical",
                                          totalCount: data[i].totalCritical,
                                          todayCount: "",
                                          color: Colors.amber),
                                    ],
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          getcoro2(
                                              color: Colors.green
                                                  .withOpacity(0.1)),
                                          Spacer(),
                                          getcoro2(
                                              color:
                                                  Colors.pink.withOpacity(0.1)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      getcoro(
                                          color: Colors.red.withOpacity(0.1)),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          getcoro2(
                                              color:
                                                  Colors.blue.withOpacity(0.1)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          getcoro2(
                                              color:
                                                  Colors.blue.withOpacity(0.1)),
                                          SizedBox(
                                            width: 50,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  getcoro({required color}) {
    return Icon(
      Icons.coronavirus_outlined,
      size: 60,
      color: color,
    );
  }

  getcoro2({required color}) {
    return Icon(
      Icons.coronavirus_rounded,
      size: 60,
      color: color,
    );
  }

  builcard(
      {required title,
      required totalCount,
      required todayCount,
      required color}) {
    return Card(
      elevation: 5,
      child: Container(
        height: 80,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "$totalCount",
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "$todayCount",
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
