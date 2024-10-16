--index를 사용하는 경우

1. where , order by , join 연산시 자주사용하는 컬럼
2. unique나 primary key 조건이 있으면 index 자동생성됨
3. 중복된 값을 가진 column이 있다면 table scan이 더 나음
4. explain query plan ~~으로 성능 조회 후에 만들어라! (추측금지)
5. table이 크면 인덱스가 좋고 작으면 하지 말아라
6. foreign key의 index도 도움이 됨.
7. 과도한 index지양. 수정이나 생성삭제시 동기화 되어야 해서 느려짐
8. 다중열을 함께 필터, 정렬하는 경우 multi column이나 composite index사용
9. =조건 컬럼을 앞에 배치, 범위조건(>,<)을 뒤 인덱스 컬럼 배치
10. 거대한 index를 만들 필요가 없다면 covering index사용
11. 변경이 잦은 열에 사용하지 말아라
12. 엄청 크고 많은 글자의 데이터 열은 b+tree대신 full text index사용 (sqlite지원 x)
