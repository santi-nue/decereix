import 'dart:typed_data';

class HelpDecode{
  static List<String> codeList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" ];
  HelpDecode();

  String getFSPEC(List<String> messageOctets) {
    String fspec = "";
    //Offset of 3 octets because of CAT (1 Octet) & LEN (2 Octets)
    for(int index = 3; index<messageOctets.length; index++)
    {
      //Convert octet and addd padding if necessary
      String newoctet = messageOctets[index];
      //Pick the 7 significant FSPEC bits -- Leaving last bit
      fspec += newoctet.substring(0, 7);
      //Check the extension bit -- Last Bit in the octet
      if (newoctet[7] == "0")
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
    int code = int.parse(string, radix:2);
    if (code == 0)
      return "None";
    else
      return codeList[code - 1];
  }
  double TwoComplement2Decimal(String bits)
  {
    if (bits[0] == "0")
    {
      return int.parse(bits, radix:2).toDouble();
    }
    else
    {
      String bitsNegative = bits.substring(1, bits.length - 1);
      String newbits = "";
      int i = 0;
      while (i < bitsNegative.length)
      {
        if (bitsNegative[i] == "1")
          newbits += "0";
        if (bitsNegative[i] == "0")
          newbits += "1";
        i++;
      }
      return -(int.parse(newbits, radix:2) .toDouble()+ 1);
    }
  }
  int Binary2Int(String bits)
  {
    return int.parse(bits, radix:2);
  }
  double Binary2Double(String bits)
  {
    return int.parse(bits, radix:2).toDouble();
  }
}
