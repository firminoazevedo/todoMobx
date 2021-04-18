import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:todomobx/services/db_utils.dart';
part 'todo_store.g.dart';

class TodoStore = _TodoStore with _$TodoStore;

abstract class _TodoStore with Store {
  String id;
  final String title;

  @observable
  bool done = false;

  _TodoStore(this.title) : id = Random().nextDouble().toString();
  _TodoStore.fromDB(this.id, this.title, this.done);

  @action
  void changeDone(){
    DBUtil.doneUpdate('todos', id, done);
    done = !done;
  }

}