//Stacks
//Challenge 1 : Reverse a List
void printInReverse<E>(List<E> list) {
  var stack = <E>[];
  for (var value in list) {
    stack.add(value);
  }
  var result = '';
  while (stack.isNotEmpty) {
    result += '${stack.removeLast()} '; // إضافة فراغ بين العناصر
  }
  print(result.trim()); // إزالة الفراغ الزائد في النهاية
}

//Challenge 2 : Balance the Parentheses
bool checkParentheses(String text) {
  var stack = <int>[];
  final open = '('.codeUnitAt(0);
  final close = ')'.codeUnitAt(0);

  for (int codeUnit in text.codeUnits) {
    if (codeUnit == open) {
      stack.add(codeUnit);
    } else if (codeUnit == close) {
      if (stack.isEmpty) {
        return false;
      } else {
        stack.removeLast();
      }
    }
  }
  return stack.isEmpty;
}

//Linked List
//Challenge 1: Print in Reverse

class Node<T> {
  T data;
  Node<T>? next;
  Node(this.data);
}

//Challenge 2: Find the Middle Node
Node<T>? findMiddle<T>(Node<T>? head) {
  if (head == null) return null;
  Node<T>? slow = head;
  Node<T>? fast = head;
  while (fast != null && fast.next != null) {
    slow = slow!.next;
    fast = fast.next!.next;
  }
  return slow;
}

// Challenge 3: Reverse a Linked List
Node<T>? reverseList<T>(Node<T>? head) {
  Node<T>? prev;
  Node<T>? current = head;
  Node<T>? next;
  while (current != null) {
    next = current.next;
    current.next = prev;
    prev = current;
    current = next;
  }
  return prev;
}

//Challenge 4: Remove All Occurrences
Node<T>? removeDuplicates<T>(Node<T>? head) {
  if (head == null) return null;

  var seen = <T>{};
  Node<T>? current = head;
  seen.add(current.data);

  while (current!.next != null) {
    if (seen.contains(current.next!.data)) {
      // حذف العقدة التالية لأنها مكررة
      current.next = current.next!.next;
    } else {
      seen.add(current.next!.data);
      current = current.next;
    }
  }
  return head;
}

void printList<T>(Node<T>? head) {
  var current = head;
  while (current != null) {
    print(current.data);
    current = current.next;
  }
}

//
void main() {
  //Stacks
  print('\n------------ 1- Stacks------------');
  print('\n------------ Challenge 1 : Reverse a List ------------\n');
  final list = [1, 2, 3, 4, 5];
  printInReverse(list);
  print('\n------------ Challenge 2 : Balance the Parentheses ------------\n');

  bool p = checkParentheses("moh()Kamel(");
  print('$p\n');
  bool pp = checkParentheses("moh()Kamel()");
  print('$pp\n');

  //
  //Linked List
  print('\n------------ 2- Linked List------------');
  print('\n------------ Challenge 1 : Print in Reverse ------------\n');
  // إنشاء قائمة مرتبطة: 1 -> 2 -> 3 -> 4 -> 5
  var head = Node(1);
  head.next = Node(2);
  head.next!.next = Node(3);
  head.next!.next!.next = Node(2);
  head.next!.next!.next!.next = Node(4);
  head.next!.next!.next!.next!.next = Node(5);
  head.next!.next!.next!.next!.next!.next = Node(4);
  printList(head);
  print('\n------------ Challenge 2: Find the Middle Node ------------\n');
  var middle = findMiddle(head);
  print('Middle node: ${middle?.data}');

  print('\n------------ Challenge 3: Reverse a Linked List ------------\n');
  var reversedHead = reverseList(head);
  print('List after the reverse: ');
  printList(reversedHead);
  print('\n------------ Challenge 4: Remove All Occurrences ------------\n');
  var updatedHead = removeDuplicates(reversedHead);
  printList(updatedHead);
}
