import 'package:flutter/material.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// 1. 창고 데이터
class PostListModel {
  List<Post> posts;
  PostListModel(this.posts);
}

// 2. 창고 (최초에 null을 넣어줄것이기 떄문에 ? 넣어줌)
class PostListViewModel extends StateNotifier<PostListModel?> {
  PostListViewModel(super._state, this.ref);

  final mContext = navigatorKey.currentContext;
  Ref ref;

  Future<void> notifyInit() async {
    // jwt 가져오기
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPostList(sessionUser.jwt!);
    state = PostListModel(responseDTO.data);
  }

  Future<void> notifyAdd(PostSaveReqDTO dto) async {
    SessionUser sessionUser = ref.read(sessionProvider);

    ResponseDTO responseDTO =
        await PostRepository().fetchPost(sessionUser.jwt!, dto);

    if (responseDTO.code == 1) {
      Logger().d("실행되니? ${responseDTO.code}");
      Post newPost = responseDTO.data as Post; // 1. dynamic(Post)
      List<Post> newPosts = [
        newPost,
        ...state!.posts
      ]; // 2. 기존 상태에 데이터 추가 [전개연산자]
      state = PostListModel(
          newPosts); // 3. 뷰모델(창고) 데이터 갱신 완료. -> watch 구독자는 rebuild됨.
      Navigator.pop(mContext!);
    } else {
      Logger().d("실행되니2? ${responseDTO.code}");
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("이거 작성 실패 : ${responseDTO.msg}")));
    }
  }
}

// 3. 창고 관리자 (View 빌드되기 직전에 생성됨)
final postListProvider =
    StateNotifierProvider.autoDispose<PostListViewModel, PostListModel?>((ref) {
  return PostListViewModel(null, ref)..notifyInit();
});
