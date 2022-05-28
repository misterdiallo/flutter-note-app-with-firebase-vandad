import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/pages/widgets/appbar_defautl.dart';

class BlocHomePage extends StatefulWidget {
  const BlocHomePage({Key? key}) : super(key: key);

  @override
  State<BlocHomePage> createState() => _BlocHomePageState();
}

class _BlocHomePageState extends State<BlocHomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
          appBar: appBarDefault(
            context,
            "Bloc Home page",
            [
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.add),
              // ),
            ],
          ),
          body: BlocConsumer<CounterBloc, CounterState>(
            listener: (context, state) {
              _controller.clear();
            },
            builder: (context, state) {
              final invalidValue = (state is CounterStateInvalidNumber)
                  ? state.invalidValue
                  : "";

              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Starting with bloc...\n\n\n"),
                      Text(
                        "Current value \n\n ${state.value}\n",
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      Visibility(
                        child: Text("Invalid input: $invalidValue"),
                        visible: state is CounterStateInvalidNumber,
                      ),
                      TextFormField(
                        controller: _controller,
                        decoration:
                            const InputDecoration(hintText: "Enter a number "),
                        keyboardType: TextInputType.number,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              context
                                  .read<CounterBloc>()
                                  .add(DecrementEvent(_controller.text));
                            },
                            icon: const Icon(Icons.remove),
                            label: const Text("Remove"),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              context
                                  .read<CounterBloc>()
                                  .add(IncrementEvent(_controller.text));
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;

  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    //
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(
          CounterStateValid(
            state.value + integer,
          ),
        );
      }
    });
    //
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(
          CounterStateValid(
            state.value - integer,
          ),
        );
      }
    });
  }
}
