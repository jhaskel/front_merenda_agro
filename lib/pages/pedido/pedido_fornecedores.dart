import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/core/bloc/entrega_bloc.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifadoAd/almoxarifadoAd.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifadoAd/almoxarifadoAd_api.dart';
import 'package:merenda_escolar/pages/entrega/Entrega.dart';
import 'package:merenda_escolar/pages/entrega/entrega_api.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:merenda_escolar/pages/pedido/pedidoAdd/PedidoAdd.dart';
import 'package:merenda_escolar/pages/pedido/pedidoAdd/PedidoAdd_api.dart';
import 'package:merenda_escolar/pages/widgets/print_button.dart';
import 'package:merenda_escolar/utils/pdf/af_pdf_pedido.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';

class PedidoFornecedores extends StatefulWidget {
  final Pedido pedido;
  final Usuario user;
  PedidoFornecedores({this.pedido, this.user});

  @override
  _PedidoFornecedoresState createState() => _PedidoFornecedoresState();
}

PedidoAdd pedidoAdd;

class _PedidoFornecedoresState extends State<PedidoFornecedores> {
  List<String> dias = [];
  List<Entrega> listItens = [];
  Usuario get user => widget.user;
  ScrollController _controller = ScrollController();
  bool isRecebido;
  var _showProgress = false;
  var _isLoading = true;
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  double totalPedido = 0;
  int total = 0;
  int _itens = 0;
  int itensRecebidos = 0;


  iniciaBloc() async {
    Provider.of<EntregaBloc>(context, listen: false)
        .fetchPedido(context, widget.pedido.id)
        .then((value) {
      setState(() {
        listItens = value;
        _isLoading = false;
        var listDias = listItens.map((e) => e.dia).toSet().toList();
        for(var x in listDias){
          dias.add(x);
        }
        var iteRecebido = listItens.where((e) => e.isrecebido == true).toList();
        _itens = listItens.length;
        itensRecebidos = iteRecebido.length;
        print("ITENS $_itens");
        print("ITENRE $itensRecebidos");
      });
    });

  }

  @override
  void initState() {
    iniciaBloc();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: _body(),


    );
  }

  _body() {
    final bloc = Provider.of<EntregaBloc>(context);
    if (bloc.lista2.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista2.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else
      return BreadCrumb(
        actions: [
          PrintButton(
            onPressed: () {
                _onClickPdf();

            },
          ),
        ],
        child: _item(),
      );
  }

  _item() {
    dias.sort((a, b) => a.toString().compareTo(b.toString()));

    return LayoutBuilder(builder: (context, constraints) {
      double limite = 600.0;
      double tela = constraints.maxWidth;
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dias.length,
            itemBuilder: (context, idx){
              var h =
              listItens.where((e) => e.dia == dias[idx]).toList();
              DateTime crea = DateTime.parse(dias[idx]);
          return Column(
            children: [
              Text("Dia ${DateFormat("dd/MM").format(crea)}",style: AppTextStyles.titleBold.copyWith(color: Colors.blue),),
              Row(
                children: [
                  Container(
                    child: Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Text(
                        'Produto',
                        style: AppTextStyles.titleBoldBlack,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text(
                      'Uni',
                      style: AppTextStyles.titleBoldBlack,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                      'Quant',
                      style: AppTextStyles.titleBoldBlack,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  tela > limite
                      ? Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                      'Valor',
                      style: AppTextStyles.titleBoldBlack,
                      textAlign: TextAlign.end,
                    ),
                  )
                      : Container(),
                  tela > limite
                      ? Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                      'Total',
                      style: AppTextStyles.titleBoldBlack,
                      textAlign: TextAlign.end,
                    ),
                  )
                      : Container(),
                  tela > limite
                      ? Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Text(
                      'For',
                      style: AppTextStyles.titleBoldBlack,
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Container(),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text(
                      '#',
                      style: AppTextStyles.titleBoldBlack,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Container(
                height: constraints.maxHeight,
                child: ListView.builder(
                    itemCount: h.length,
                    itemBuilder: (context, index) {
                      Entrega i = h[index];
                      isRecebido = i.isrecebido;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                fit: FlexFit.tight,
                                child: Text(i.alias),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text(i.unidade),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Text(
                                  i.quantidade.toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              tela > limite
                                  ? Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Text(
                                  'R\$ ${formatador.format(i.valor)}',
                                  textAlign: TextAlign.end,
                                ),
                              )
                                  : Container(),
                              tela > limite
                                  ? Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Text(
                                  'R\$ ${formatador.format(i.quantidade * i.valor)}',
                                  textAlign: TextAlign.end,
                                ),
                              )
                                  : Container(),
                              tela > limite
                                  ? SizedBox(
                                width: 5,
                              )
                                  : Container(),
                              tela > limite
                                  ? Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(right: 5),
                                  child: Text(
                                    i.fornecedor,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                                  : Container(),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child:
                                    user.isUnidade()
                                    ? MergeSemantics(
                                  child: CupertinoSwitch(
                                    value: isRecebido,
                                    onChanged:
                                        (bool newValue) async {
                                      setState(() {
                                        isRecebido = newValue;
                                      });
                                      recebeProduto(newValue, i);
                                    },
                                  ),
                                )
                                    : MergeSemantics(
                                  child: CupertinoSwitch(
                                    value: i.isrecebido,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(thickness: 1.2)
                        ],
                      );
                    }),
              ),
            ],
          );
        }),
      );
    });
  }

  _onClickPdf() {
    print("dias.length ${dias.length}");
   PagesModel.get(context)
        .push(PageInfo("Imprimir", AfPdfPedido(widget.pedido,listItens,dias)));
  }


  recebeProduto(bool newValue, Entrega dados) async {
    print("NOVALOR $newValue");
    if (newValue) {
      setState(() {
        itensRecebidos++;
      });
      print("ITENR $itensRecebidos");
      var dado = dados ?? Entrega();
      dado.isrecebido = newValue;
      EntregaApi.save(context, dado);

      if (dados.licitacao==2) {
        AlmoxarifadoAd almo;
        var alm = almo ?? AlmoxarifadoAd();
        alm.escola = dados.escola;
        alm.produto = dados.produto;
        alm.alias = dados.alias;
        alm.categoria = dados.categoria;
        alm.unidade = dados.unidade;
        alm.created = DateTime.now().toIso8601String();
        alm.nomeescola = dados.nomeescola;
        alm.licitacao = dados.licitacao;
        alm.quantidade = dados.quantidade.toInt();
        alm.isativo = true;
        alm.istroca = false;
        alm.obs = "Adicionou ${dados.quantidade} na dispensa!";
        AlmoxarifadoAdApi.save(context, alm);
      }
      if (itensRecebidos == _itens) {
        var ped = pedidoAdd ?? PedidoAdd();
        ped.id = pedidoAdd.id;
        ped.status = Status.entregue;
        ped.ischeck = true;
        await PedidoAddApi.save(context, ped);
      }
    } else {
      print("aqui");
      setState(() {
        itensRecebidos--;
      });

      AlmoxarifadoAd almo;
      var alm = almo ?? AlmoxarifadoAd();
      alm.escola = dados.escola;
      alm.produto = dados.produto;
      alm.alias = dados.alias;
      alm.categoria = dados.categoria;
      alm.unidade = dados.unidade;
      alm.created = DateTime.now().toIso8601String();
      alm.nomeescola = dados.nomeescola;
      alm.licitacao = dados.licitacao;
      alm.quantidade = dados.quantidade.toInt() * -1;
      alm.isativo = true;
      alm.istroca = false;
      alm.obs = "Retirou ${dados.quantidade} na dispensa!";
      AlmoxarifadoAdApi.save(context, alm);
      print("ITENR $itensRecebidos");
      var dado = dados ?? Entrega();

      dado.isrecebido = newValue;
      EntregaApi.save(context, dado);
      if (dados.licitacao==2) {
         AlmoxarifadoAd  almo;
      var alm = almo ?? AlmoxarifadoAd();
      AlmoxarifadoAdApi.delete(context, alm);
    }

      }
    }
  }


