
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:merenda_escolar/core/bloc/af_bloc.dart';
import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:merenda_escolar/pages/af/afAdd/Af.dart';
import 'package:merenda_escolar/pages/af/afAdd/af_api.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:provider/provider.dart';

class EnviarArquivo extends StatefulWidget {
  Af af;
  EnviarArquivo(this.af);

  @override
  _EnviarArquivoState createState() => _EnviarArquivoState();
}

class _EnviarArquivoState extends State<EnviarArquivo> {

  fb.UploadTask _uploadTask;
  String image;
  Image imagem;
  double progressPercent = 0;
  String msg = 'Selecione um arquivo pdf!';
  bool _showProgress = false;
  AfAdd afAdd;

  montaAfAdd(Af ordem){
    afAdd= AfAdd(
      id:ordem.id,
      nivel:ordem.nivel,
      setor:ordem.setor,
      code:ordem.code,
      fornecedor:ordem.fornecedor,
      isenviado:ordem.isenviado,
      status:ordem.status,
      isativo:ordem.isativo,
      createdAt:ordem.createdAt,
      processo:ordem.processo,
      despesa:ordem.despesa,
      despesax:ordem.despesax,
      isdespesa:ordem.isdespesa,

    );
  }

  @override
  void initState() {
    super.initState();
    montaAfAdd(widget.af);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),    );
  }

  _body() {

    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child:  Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text(''),
                  ),

                  StreamBuilder<fb.UploadTaskSnapshot>(
                    stream: _uploadTask?.onStateChanged,
                    builder: (context, snapshot) {
                      final event = snapshot?.data;


                      // Default as 0
                      progressPercent = event != null
                          ? event.bytesTransferred / event.totalBytes * 100
                          : 0;
                      if (progressPercent == 100) {

                        snapshot.data.ref.getDownloadURL().then((value) {
                          setState(() {
                            image = value.toString();
                            msg = 'Arquivo enviado com Sucesso!';
                          });

                        });
                        return image != null
                            ? InkWell(
                            onTap: ()async{ await uploadImage();},
                            child: Column(
                              children: [
                                Text(msg),
                                FlatButton(onPressed: () async {
                                 await _onClickSalvar();
                                  pop(context);

                                }, child: Text('Retornar'))
                              ],

                            )
                        )
                            : Text("");
                      } else if (progressPercent == 0) {


                        return InkWell(
                            onTap: ()async{ await uploadImage();},
                            child: Column(
                              children: [
                                Icon(Icons.file_download,size: 120,),
                                msg != null ? Text(msg) : Text('')
                              ],
                            )
                        );
                      } else {

                        return LinearProgressIndicator(
                          value: progressPercent,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }

  uploadToFirebase(File file) async {

    final extensao = file.type.split('/');
    print(extensao);
    String ext = extensao[1];
    print("modficado=${ext[1]}");

    if(ext == 'pdf' ||  ext== 'jpeg' || ext == 'png'){
      if(file.size > 500000){

        setState(() {
          msg = 'Imagem muito grande!';
        });

        print('Imagem muito grande ${file.size}');

      }else{
        final filePath = 'agrolandia/ordem/${widget.af.code}/${DateTime.now().hashCode}.${ext}';
        print(filePath);
        final ref = "gs://app-merenda-escolar.appspot.com/";
        setState(() {

          _uploadTask = fb
              .storage()
              .refFromURL(ref)
              .child(filePath)
              .put(file);

        });


      }

    }else{
      setState(() {
        msg = 'Documentos precisa ser imagem ou arquivo pdf!';
      });

      print('Documentos precisa ser imagem ou arquivo pdf!');
    }





  }

  uploadImage() async {
    setState(() {
      msg='Selecione uma imagem ou arquivo pdf!';
    });

    // HTML input element
    InputElement uploadInput = FileUploadInputElement();

    uploadInput.click();

    uploadInput.onChange.listen(
          (changeEvent) {
        final  file = uploadInput.files.first;

        final reader = FileReader();

        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen(
              (loadEndEvent) async {
            setState(() {
              uploadToFirebase(file);
            });
          },
        );
      },
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    //  Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  _onClickSalvar() async {
    var afbloc = Provider.of<AfBloc>(context, listen: false);

      var cate = afAdd ?? AfAdd();
      cate.status = Status.ordemEmpenhada;
      cate.empenho = image;
      await AfAddApi.save(context, cate);
     afbloc.decItensAutorizados(1);


  }

  @override
  void dispose() {
    _uploadTask?.cancel();
    super.dispose();
  }


}
