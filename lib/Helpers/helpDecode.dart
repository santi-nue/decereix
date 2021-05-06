import 'dart:typed_data';

class HelpDecode{
  static List<String> codelist = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" ];
  HelpDecode();

  String getFSPEC(List<String> messageOctets) {
    String fspec = "";
    //Offset of 3 octets because of CAT (1 Octet) & LEN (2 Octets)
    for(int index = 3; index<messageOctets.length; index++)
    {
      //Pick the 7 significant FSPEC bits -- Leaving last bit
      fspec += messageOctets[index].substring(0, 7);
      //Check the extension bit -- Last Bit in the octet
      if (messageOctets[index][7] == "1")
        index++;
      else
        //Stop reading when extension bit is 0
        break;
    }
    return fspec;
  }
  int decimal2Octal(int number)
  {
    int octal = 0, i = 1;
    while (number != 0)
    {
      octal += (number % 8) * i;
      number =  number ~/ 8;
      i *= 10;
    }
    return octal;
  }
  String computeChar(String string)
  {
    int code = int.parse(string);
    if (code == 0)
      return "None";
    else
      return codelist[code - 1];
  }
  double TwoComplement2Decimal(String bits)
  {
    return int.parse(bits, radix:2).toDouble();
  }

}