import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_list/app/adapters/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:to_do_list/app/interfaces/local_storage_service_interface.dart';
import 'package:to_do_list/app/services/errors/repository_errors.dart';

class LocalStorageService implements ILocalStorageService {
  @override
  Future<Either<DeleteFailure, bool>> delete(Movie movie) async {
    try {
      var box = Hive.box<Movie>('movies');
      await box.delete(movie.key);
      return Right(true);
    } catch (e) {
      return Left(DeleteFailure());
    }
  }

  @override
  get(String key) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Either<bool, List<Movie>>> getAll() async {
    try {
      var box = Hive.box<Movie>('movies');
      List<Movie> movies = box.values.toList();
      return Right(movies);
    } catch (e) {
      return Left(false);
    }
  }

  @override
  Future<Either<SaveFailure, bool>> insert(Movie movie) async {
    try {
      var box = Hive.box<Movie>('movies');
      await box.add(movie);
      return Right(true);
    } catch (e) {
      return Left(SaveFailure());
    }
  }

  @override
  Future<Either<UpdateFailure, bool>> put(Movie movie) async {
    try {
      var box = Hive.box<Movie>('movies');

      await box.put(movie.key, movie);

      return Right(true);
    } catch (e) {
      return Left(UpdateFailure());
    }
  }
}
