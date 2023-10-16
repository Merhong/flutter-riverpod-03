import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// 창고 데이터
class Model {
  int num;

  Model(this.num);
}

// 창고 class(상태, 행위)
// (Provider - 상태, StateNotifierProvider - 상태 + 메서드)
class ViewModel extends StateNotifier<Model?> {
  ViewModel(super.state);

  // model의 초기값을 정해주는 메서드 (초기화)
  void init() {
    // 통신 코드
    state = Model(1); // 부모의 state값을 바꿔줘야 함.
  }

  void change() {
    // state = state + 1; // state 자체가 모델이라 불가능
    // state.num = state.num + 1; 가 맞는 표현임
    state = Model(2);

    // state 값을 받아와서 상태값을 변경해 줘야함!!!
    // state가 창고 데이터이고 모델임
    // Model? model = state;
    // model?.num++;
    // state = model;
  }
}

// 창고 관리자
// StateNotifierProvider<창고, 창고데이터 타입>
// final myNumProvider = StateNotifierProvider<Mynum, int>((ref) {},);
// 창고 데이터가 2개 이상이면? 클래스로 만들어서 사용해야함.
// 하지만 코드컨벤션시 헷갈리지 않도록 1개라도 클래스를 만들어쓰기
// Provider일 경우 Model만 관리한다.
final numProvider = StateNotifierProvider<ViewModel, Model?>((ref) {
  // 통신을 하게 된다면 await와 async를 붙여야 되는데 이건 FutureProvider를 써야하는데...?
  // 이는 창고에 데이터가 비어있다가 통신이 이뤄진 후 그림이 그려짐
  // SNP를 쓰면 통신코드를 실행시켜놓고 창고에는 null을 넣어줌
  // 통신 완료시 null에서 데이터 변경이 일어남, 이 변경을 수신하여서 그림을 그려줌
  // Model? model = null; // 상태가 null을 관리하기 위한 null 처리
  // 위의 코드를 생략한 이유는 Model 생성시 선택적 생성자로 처리했으므로.
  return ViewModel(null)..init(); // Cascade 연산자
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 화면 2개로 분할
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              MyText1(),
              MyText2(),
              MyText3(),
              MyButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends ConsumerWidget {
  const MyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () {
          ref.read(numProvider.notifier).change(); // ViewModel(창고)에 접근 가능
        },
        child: Text("상태변경"));
  }
}

class MyText3 extends StatelessWidget {
  const MyText3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("5", style: TextStyle(fontSize: 30));
  }
}

class MyText2 extends ConsumerWidget {
  const MyText2({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // numProvider를 수신
    Model? model = ref.watch(numProvider);

    if (model == null) {
      return CircularProgressIndicator();
    } else {
      return Text("${model.num}", style: TextStyle(fontSize: 30));
    }
  }
}

class MyText1 extends ConsumerWidget {
  const MyText1({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // numProvider를 수신
    Model? model = ref.watch(numProvider);

    if (model == null) {
      return CircularProgressIndicator();
    } else {
      return Text("${model.num}", style: TextStyle(fontSize: 30));
    }
  }
}
