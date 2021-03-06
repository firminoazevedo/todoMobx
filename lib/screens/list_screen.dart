import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:todomobx/services/db_utils.dart';
import 'package:todomobx/stores/list_store.dart';
import 'package:todomobx/stores/login_store.dart';
import 'package:todomobx/stores/todo_store.dart';
import 'package:todomobx/widgets/custom_icon_button.dart';
import 'package:todomobx/widgets/custom_text_field.dart';

import 'login_screen.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  ListStore listStore = ListStore();
  TextEditingController _tarefasFieldController = TextEditingController();

  Future<void> _loadFromDB() async {
    var db = await DBUtil.getData('todos');
    print(db);
    var todos = db
        .map((todo) => TodoStore.fromDB(
            todo['id'], todo['title'], todo['isDone'] == 1 ? true : false))
        .toList();
    listStore.addFromDB(todos);
  }

  @override
  void initState() {
    super.initState();
    _loadFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Tarefas',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 32),
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      color: Colors.white,
                      onPressed: () {
                        Provider.of<LoginStore>(context, listen: false)
                            .logout();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Observer(builder: (_) {
                          return CustomTextField(
                            controller: _tarefasFieldController,
                            hint: 'Tarefa',
                            onChanged: listStore.setNewTodoTitle,
                            suffix: listStore.newTodoTitle.isEmpty
                                ? null
                                : CustomIconButton(
                                    radius: 32,
                                    iconData: Icons.add,
                                    onTap: () {
                                      listStore.addTodo();
                                      _tarefasFieldController.clear();
                                    },
                                  ),
                          );
                        }),
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: Observer(
                            builder: (_) {
                              return ListView.separated(
                                itemCount: listStore.todoList.length,
                                itemBuilder: (_, index) {
                                  final todo = listStore.todoList[index];
                                  return Observer(
                                    builder: (_) {
                                      return ListTile(
                                        title: Text(
                                          todo.title,
                                          style: TextStyle(
                                              decoration: todo.done
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                              color: todo.done
                                                  ? Colors.grey
                                                  : Colors.black),
                                        ),
                                        onTap: () {
                                          todo.changeDone();
                                          listStore.sortList();
                                        },
                                        trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){
                                          listStore.remove('todos', 'id', todo.id, todo);
                                        }),
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (_, __) {
                                  return Divider();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
