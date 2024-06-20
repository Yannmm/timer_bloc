import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_bloc/timer/bloc/timer_bloc.dart';

class TimerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Good Timer'),
        ),
        body: const Stack(
          children: [
            Background(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 100),
                  child: Center(
                    child: TimerText(),
                  ),
                ),
                Actions(),
              ],
            )
          ],
        ),
      );
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
        builder: (context, state) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...switch (state) {
              TimerInitial() => [
                  FloatingActionButton(
                      child: const Icon(Icons.play_arrow),
                      onPressed: () => context
                          .read<TimerBloc>()
                          .add(TimerStarted(duration: state.duration)))
                ],
              TimerRunInProgress() => [
                  FloatingActionButton(
                      child: const Icon(Icons.pause),
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerPaused())),
                  FloatingActionButton(
                      child: const Icon(Icons.replay),
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerReset()))
                ],
              TimerRunPause() => [
                  FloatingActionButton(
                      child: const Icon(Icons.play_arrow),
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerResumed())),
                  FloatingActionButton(
                      child: const Icon(Icons.replay),
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerReset()))
                ],
              TimerRunComplete() => [
                  FloatingActionButton(
                      child: const Icon(Icons.replay),
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerReset()))
                ]
            }
          ],
        ),
      );
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minstring = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secstring = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minstring:$secstring',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade500,
          ],
        ),
      ),
    );
  }
}
