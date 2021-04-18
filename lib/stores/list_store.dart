import 'package:mobx/mobx.dart';
import 'package:todomobx/services/db_utils.dart';
import 'package:todomobx/stores/todo_store.dart';
part 'list_store.g.dart';

class ListStore = _ListStore with _$ListStore;

abstract class _ListStore with Store {
  @observable
  String newTodoTitle = "";

  @observable
  bool isEmpty = true;

  @action
  void changeIsEmpty() => isEmpty = !isEmpty;

  @action
  void setNewTodoTitle(String value) => newTodoTitle = value;

  ObservableList<TodoStore> todoList = ObservableList<TodoStore>();

  @action
  void addFromDB(List<TodoStore> todos) {
    todoList.addAll(todos);
    sortList();
  }

  void sortList() => todoList.sort((a, b) {
      if (a.done) return 1;
      return -1;
    });

  void addTodo() {
    final todo = TodoStore(newTodoTitle);
    todoList.insert(0, todo);
    DBUtil.insert('todos', {
      'id': todo.id,
      'title': todo.title,
      'isDone': todo.done ? 1 : 0,
    });
    newTodoTitle = '';
    print(todo.id);
  }
}
