import { Navigate } from "react-router-dom";
import { auth } from "../firebase";
import { useEffect, useState } from "react";
import { onAuthStateChanged } from "firebase/auth";
//app.tsx에서 설정한 ProtectedRoute의 children (home,profile)을 받아옴
export default function ProtectedRoute({
    children,
    } : {
    children:React.ReactNode;
}) {
    //현재 로그인 상태를 바로 받아서 확인 (추가코드...)
    const [user,setUser] = useState(auth.currentUser);
    useEffect(() => {
        const unsubscribe = onAuthStateChanged(auth, (authUser) => {
            setUser(authUser);
        });
        
        return () => {
            unsubscribe();
        };
        }, []);

    //유저 정보 요청해서 없으면 로그인 페이지로 
    //const user = auth.currentUser;
    if(user === null){
        return <Navigate to ="/login"/>
    }
    return children
}