import React, { useState } from "react";
import { Link, useActionData, useNavigate } from "react-router-dom";
import { auth } from "../firebase";
import { FirebaseError } from "firebase/app";
import { signInWithEmailAndPassword } from "firebase/auth";
import { Error, Form, Input, Switcher, Title, Wrapper } from "../components/auth-components";
import GithubButton from "../components/github-btn";

//이런식으로 에러코드를 치환하여 사용 가능(현재는 미사용)
//const errors = {
//    "auth/email-already-in-use" : "That email already exists."
//};

export default function Login(){
    const navigate = useNavigate();
    const [isLoading,setLoading] =useState(false);
    const [email,setEmail] = useState("");
    const [password,setPassword] = useState("");
    //에러 확인
    const [error,setError ] =useState("");

    const onChange =(e : React.ChangeEvent<HTMLInputElement>)=> {
        const {target:{name,value}} =e;

         if (name ==="email"){
            setEmail(value)
        }else if(name==="password"){
            setPassword(value)
        }
    } 

    const onSubmit= async(e : React.FormEvent<HTMLFormElement>) => {
        e.preventDefault ();
        setError("");
        if (isLoading || email === "" || password === "") return;

        //사용자 계정 확인
        try {
            setLoading(true);
                //로그인 함수
            await signInWithEmailAndPassword(auth,email,password);
           //3. redirect to the home page
            navigate("/");

        } catch (e){
            //이미 계정이 있거나 비밀번호가 유효하지 않은 경우
           if(e instanceof FirebaseError){
            setError(e.message);
           }

        } finally{
            setLoading(false);
        }
       // console.log(name,email,password);
    }
    return (
    <Wrapper>
        <Title>Log into X</Title>
        <Form onSubmit={onSubmit}>
           <Input onChange={onChange} name ="email" value={email} placeholder="Email" type="email" required/>
            <Input onChange={onChange} name ="password" value={password} placeholder="Password" type="password" required/>
            <Input  type="submit" value= {isLoading ? "Loading...": "Login"}/>
        </Form>
        {error !== "" ? <Error>{error}</Error> : null}
        <Switcher>
            Don't have an account? <Link to ="/create-account">Create one &rarr;</Link>
        </Switcher>
        <GithubButton/>
    </Wrapper>
    );
}