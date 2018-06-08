import 'package:cesufood_app/classes/produto.dart';
import 'package:cesufood_app/produto_page/produto_page.dart';
import 'package:flutter/material.dart';

class CardProduto extends StatefulWidget {
  final Produto produto;

  const CardProduto(this.produto, {Key key}) : super(key: key);

  @override
  CardProdutoState createState() {
    return new CardProdutoState();
  }
}

class CardProdutoState extends State<CardProduto>
    with TickerProviderStateMixin {
  AnimationController fotoAnimationController;

  Widget _getImage(url) {
    return new FutureBuilder(
      future: widget.produto.getImage,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          fotoAnimationController.forward();
          return new Opacity(
            opacity: fotoAnimationController.value,
            child: new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: new MemoryImage(snapshot.data),
                ),
              ),
            ),
          );
        } else {
          return new Center(
            child: new CircularProgressIndicator(
              backgroundColor: Theme.of(context).accentColor,
            ),
          );
        }
      },
    );
  }

  void _rebuild() {
    setState(() => {});
  }

  @override
  void initState() {
    super.initState();

    fotoAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(() => _rebuild());
  }

  @override
  void dispose() {
    fotoAnimationController.dispose();
    super.dispose();
  }

  void viewProduto(context){
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new ProdutoPage(widget.produto);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      child: new Material(
        child: new InkWell(
          onTap: () => viewProduto(context),
          onLongPress: () => {},
          child: new Column(
            children: <Widget>[
              new Hero(
                tag: 'produto'+widget.produto.id.toString(),
                child: new Container(
                  height: 150.0,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: widget.produto.imageProvider,
                    ),
                  ),
                ),
              ),
              new ListTile(
                title: new Text(widget.produto.nome),
                subtitle: new Row(
                  children: <Widget>[
                    new Text(widget.produto.valorMask),
                    new Expanded(child: Container()),
                    new IconButton(
                      icon: new Icon(
                        widget.produto.isFavoritado
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Color(0xFFFF4444),
                      ),
                      onPressed: () {
                        setState(() {
                          widget.produto.isFavoritado =
                              !widget.produto.isFavoritado;
                          //TODO mandar request favoritar
                        });
                      },
                    ),
                    new IconButton(
                      icon: new Icon(
                        Icons.add_shopping_cart,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        /* ... */
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
