import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class MenuService {
  
  static Future<Map<String, dynamic>> fetchMenu() async {
    final response = await http.get(Uri.parse('https://kahramanmaras.bel.tr/personel/yemek-menusu'));
  
    if (response.statusCode == 200) {
      var document = parser.parse(response.body);

      var menuDate = document.querySelector('.date-display-single')?.text.trim() ?? '';
      List<String> menuItems = document
          .querySelectorAll('.field.field-type-text .field-item')
          .map((item) => item.text.trim())
          .toList();
      List<String> weeklyMenu = document
          .querySelectorAll('.views-table tbody tr')
          .map((item) => item.text.trim())
          .toList();

      return {
        'menuDate': menuDate,
        'menuItems': menuItems,
        'weeklyMenu': weeklyMenu,
      };
    } else {
      throw Exception('Failed to load menu');
    }
  }

   static Future<String> fetchData(String tcNumber) async {
    var url = Uri.parse('https://yemekhaneodeme.kahramanmaras.bel.tr/Sorgula.aspx');

    var headers = {
      "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
      "accept-language": "tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7",
      "cache-control": "max-age=0",
      "content-type": "application/x-www-form-urlencoded",
      "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Opera\";v=\"112\"",
      "sec-ch-ua-mobile": "?1",
      "sec-ch-ua-platform": "\"Android\"",
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "same-origin",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1"
    };

    var body = "__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=Vn%2Bg6OTbmsOnkpXuZMsT7NOGaxbayjnKCBSXlDYrOxKCe7BhU6ph%2FwpA14ccTVf2wFgYD6APsbYaJL8ptIpzTroCzn3sSFDUcMmJ5WNhBKMZ9AQQdSvP85ImgU7O3KpDSG67yHxDLllwWOYyaQCJgosIHolwM66h%2FFTNy77PFCRNCef%2Bii83flLZ1nUZF0EHsch8xkAcjc2JPHGqve4JpHQF82FaiD04DO8XDSQRIdjbHDxx%2FUvhUtkc1Qx%2BUafTvmEF8KcEDiVHfh88UlQfahqhfWx5ljEIFz7j1l8x5l%2B6wPdNVPLPy9103SHe%2FZYMeiqngZnZZRyaZhL1KMHsu63HHSYtxXaTqtiqCAv1C7Fu%2FAAhnTdtmU74F8Jxp4O8hhSBAtH%2BOGw8Rrfpjq2jxSAjaJIDDHOx5tq5L8%2BI9aShLy%2FFUZPoW0wYNdn9quiz4zWMg2e8%2Bpp2wGd7vSjpaSLQdTgR8%2B4wOMjIfIuy2XhSbf4bl9LuFE%2FQqSRAA58FTBHxtdcS2GQOVxcsxeV18DfHKvIfczOOgL3v0uuAeEf1ycDkwJfZG674zvpzqyV8&__VIEWSTATEGENERATOR=9A7F246F&__EVENTVALIDATION=EV%2Fds%2FolgDUtgfHWpPX%2FqFCdUuN9SBAv1gIhMl3W3T1n5V97IkqjHpr%2BxRnprXq%2BfmgT59HLugJfEkfKvDJCV%2F2MVJPQNB5KCdAwn%2FItalXjjIFQG6ZQBxzVO7APB8KEeXERyFO%2BsKm0wKHOuSFYlQ%3D%3D&ctl00%24ContentPlaceHolder1%24txTcNo=$tcNumber&ctl00%24ContentPlaceHolder1%24BtnSorgula=S%C4%B0C%C4%B0L+SORGULA";

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);
    
      var balanceElement = document.querySelector('#table-ext-1 tbody tr td:nth-child(10)');
    
      if (balanceElement != null) {
        return balanceElement.text.trim();
      } else {
        return 'Bakiye bilgisi bulunamadı.';
      }
    } else {
      throw Exception('Veri alırken hata oluştu: ${response.statusCode}');
    }
  }

}







//   static Future<Map<String, dynamic>> submitForm(String tcNo) async {
//     final url = Uri.parse('https://yemekhaneodeme.kahramanmaras.bel.tr/Sorgula.aspx');

//     // GET isteği ile sayfadan VIEWSTATE ve EVENTVALIDATION değerlerini alın
//     final response = await http.get(url);
//     var document = parser.parse(response.body);

    
//     var viewState = document.querySelector('input[name="__VIEWSTATE"]')?.attributes['HvRs0RQ81ERuAQnWZbVhi/kn4QeIoafULigkwGxIojLiS6exi2tO1RqmyyTqix6IHcKJOoflHxAwjUJ9vDSF+hqJahYIiJls5UXrxXn7qVe7wm7nD6jsQMZKkMi5zLmbXyPmOJNk1/u0NWccieRKbtYMmMjuITxoHGA7yJv6cE00W3uuiSvgYdHGjHRqJ4gJfiefViyew7q0qsgg025e+7lGBCgtmoe+ZFbWcGXj7gGov0cwjc7k6gZHvHDP2VFcjioEMmabjY+wO2gdxvFjKyfXkUGbL47W/oOxiX3knX6DWlfLcKrpDt1YoSC9RNR5xhyzWGnCnSXD3+pHXi+ml/GFT8QQjWuhCNeeLjioBgRcPj8UPZ9FFGZvjIMNYc0d70TwSEjjnJ2w/Z3lu29SUAbBaL+QeMgDGFVKxUqca8bsRF0bTTVUzcfhQvgawy9+rgDgS+HPV33k+eRQ3Pwjn0SbnWpOfo1OrTabfDJBUIRu0kfL2PV4Da73MsSTDYZLwXqByX1QqhFy2ho/JodqVpmUcqP12D4UGO/ECfPlY9Zh/9+Jt5YbZuX5Z4Z667zB'];
//     var eventValidation = document.querySelector('input[name="__EVENTVALIDATION"]')?.attributes['BBPcWtWn27B7t5qXuYjy3Nzd0+8/HaKuakET4u9eXbYTb96S7K26zXkrJLt2PQXWFl8crNUHL+B+49yJ9vuQHCNZBopHWrfvhSvxOBrkIbYW+m5zNUSGZA5QXLC6KFwUtistGF0c+YLIweMMf3btiA=='];
//     var viewStateGenerator = document.querySelector('input[name="__VIEWSTATEGENERATOR"]')?.attributes['9A7F246F'];

  
//     final postResponse = await http.post(url, body: {
//       'txTcNo': tcNo, 
//       '__VIEWSTATE': viewState,
//       '__EVENTVALIDATION': eventValidation,
//       '__VIEWSTATEGENERATOR': viewStateGenerator,
//       '__EVENTTARGET': '',
//       '__EVENTARGUMENT': '', 
//     });

//     if (postResponse.statusCode == 200) {
//       var resultDocument = parser.parse(postResponse.body);

      
//       List<String> bakiyeBilgi = resultDocument.querySelectorAll('.tab-content.table-responsive tbody tr') 
//           .map((element) => element.text.trim())
//           .toList();

//       return {
//         'bakiyeBilgi': bakiyeBilgi,
//       };
//     } else {
//       throw Exception('Sorgulama başarısız');
//     }
//   }
// }
  // static Future<String> fetchPostData(String tcNumber) async {
  //   final url = Uri.parse('https://yemekhaneodeme.kahramanmaras.bel.tr/Sorgula.aspx'); 

  //   // POST isteği için gerekli veriler
  //   final body = 'tcNumber=$tcNumber'; // Form-urlencoded formatı

  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/x-www-form-urlencoded',
  //     },
  //     body: body,
  //   );

  //   if (response.statusCode == 200) {
  //     final contentType = response.headers['content-type']?.toLowerCase() ?? '';

  //     if (contentType.contains('application/javascript')) {
  //       final jsContent = response.body;
  //       final jsonMatch = RegExp(r'\{.*?\}').firstMatch(jsContent);

  //       if (jsonMatch != null) {
  //         try {
  //           final jsonResponse = json.decode(jsonMatch.group(0)!);
  //           return jsonResponse.toString();
  //         } catch (e) {
  //           print('JSON ayrıştırma hatası: $e');
  //           return 'JSON ayrıştırma hatası: $e';
  //         }
  //       } else {
  //         print('JSON içeriği bulunamadı.');
  //         return 'JSON içeriği bulunamadı.';
  //       }
  //     } else if (contentType.contains('text/html')) {
  //       // HTML içeriğini ayrıştır
  //       var document = parser.parse(response.body);
        
  //       // Bakiye bilgisini içeren HTML elemanını seçin
  //       var bakiyeElement = document
  //           .querySelector('.table-responsive #table-ext-1 tbody tr td:nth-child(6)'); // 6. sütundaki <td> elemanını seçiyoruz
        
  //       var bakiyeBilgisi = bakiyeElement?.text.trim() ?? 'Bakiye bilgisi bulunamadı.';
        
  //       return bakiyeBilgisi;
  //     } else {
  //       print('Beklenen JSON yerine başka bir içerik türü alındı.');
  //       return 'Beklenen JSON yerine başka bir içerik türü alındı.';
  //     }
  //   } else {
  //     throw Exception('Failed to fetch post data');
  //   }
  // }
