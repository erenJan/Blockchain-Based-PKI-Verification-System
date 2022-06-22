import 'package:flutter/material.dart';
import 'display_certificate.dart';
import 'package:beChain/wallet/style/style.dart';

void CertificatePopUp(context,signature){
  showModalBottomSheet(
    isScrollControlled:true,
    isDismissible: true,
    enableDrag: true,
    context: context, 
    backgroundColor: Colors.transparent,
    builder: (BuildContext context){
      return DraggableScrollableSheet(
        builder: (context, scrollController) {
        return Container(
          height: 900,
          color: Colors.transparent,
          child: Container(
            decoration: new BoxDecoration(
              color: background,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(40),
                topRight: const Radius.circular(40)
              ),
              boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 1.5,
                  ),
                ],
            ),
            child: Certificate(signature_value:signature)
          )
        
      );
    }
  );
}
  );
}