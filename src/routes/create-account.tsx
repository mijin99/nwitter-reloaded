import { createUserWithEmailAndPassword, updateProfile } from "firebase/auth";
import React, { useState } from "react";
import { Link, useActionData, useNavigate } from "react-router-dom";
import { auth } from "../firebase";
import { FirebaseError } from "firebase/app";
import { Error, Form, Input, Switcher, Title, Wrapper } from "../components/auth-components";
import GithubButton from "../components/github-btn";

//이런식으로 에러코드를 치환하여 사용 가능(현재는 미사용)
//const errors = {
//    "auth/email-already-in-use" : "That email already exists."
//};



export default function CreateAccount(){
    const navigate = useNavigate();
    const [isLoading,setLoading] =useState(false);
    const [name,setName] = useState("");
    const [email,setEmail] = useState("");
    const [password,setPassword] = useState("");
    //에러 확인
    const [error,setError ] =useState("");

    const onChange =(e : React.ChangeEvent<HTMLInputElement>)=> {
        const {target:{name,value}} =e;
        if(name === "name"){
            setName(value)
        } else if (name ==="email"){
            setEmail(value)
        }else if(name==="password"){
            setPassword(value)
        }
    } 

    const onSubmit= async(e : React.FormEvent<HTMLFormElement>) => {
        e.preventDefault ();
        setError("");
        if (isLoading || name === "" || email === "" || password === "") return;
        //사용자 계정생성 start 
        try {
            setLoading(true);
            //1. create an account
            const credentials =  await createUserWithEmailAndPassword(auth, email,password);
            //2. set the name of the user profile
            await updateProfile(credentials.user,{displayName: name});
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
        <Title>Join X</Title>
        <Form onSubmit={onSubmit}>
            <Input onChange={onChange} name ="name" value ={name} placeholder="Name" type="text" required/>
            <Input onChange={onChange} name ="email" value={email} placeholder="Email" type="email" required/>
            <Input onChange={onChange} name ="password" value={password} placeholder="Password" type="password" required/>
            <Input  type="submit" value= {isLoading ? "Loading...": "Create Account"}/>
        </Form>
        {error !== "" ? <Error>{error}</Error> : null}
        <Switcher>
            Already have an account?{""} <Link to ="/login">Log in &rarr;</Link>
        </Switcher>
        <Switcher>
            Did you forget your password?
            <Link to="/change-password"> Change Password &rarr;</Link>
        </Switcher>
        <GithubButton/>
    </Wrapper>
    );
}