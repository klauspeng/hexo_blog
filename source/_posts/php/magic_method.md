---
title: php魔术方法及魔法常量
date: 2018/10/9
categories: 
---

php魔术方法及魔法常量的理解及使用
<!-- more -->


## `__get` `__set` `__isset` `__unset`
1. 从一个难以访问的属性读取数据的时候 __get() 方法被调用
2. 向一个难以访问的属性赋值的时候 __set() 方法被调用
3. 难以访问包括：（1）私有属性，（2）没有初始化的属性

```php
protected $config =   array(
    'maxSize'           =>  -1,    // 上传文件的最大值
    'allowExts'         =>  array(),    // 允许上传的文件后缀 留空不作后缀检查
    'allowTypes'        =>  array(),    // 允许上传的文件类型 留空不做检查    
    'savePath'          =>  '',// 上传文件保存路径
    'saveRule'          =>  'uniqid',// 上传文件命名规则
    'hashType'          =>  'md5_file',// 上传文件Hash规则函数名
    );

public function __get($name){
    if(isset($this->config[$name])) {
        return $this->config[$name];
    }
    return null;
}

public function __set($name,$value){
    if(isset($this->config[$name])) {
        $this->config[$name]    =   $value;
    }
}

public function __isset($name){
    return isset($this->config[$name]);
}
```

## `__construct` `__destruct`
`__construct` 类的构造函数--初始化

`__destruct()`，类的析构函数--销毁一个类之前执行

```php
class Person{   
                            
  public $name;     
  public $age;     
  public $sex;     
                                  
  public function __construct($name="", $sex="男", $age=22)
  {  
    $this->name = $name;
    $this->sex = $sex;
    $this->age = $age;
  }
  
  /**
   * say 说话方法
   */
  public function say()
  { 
    echo "我叫：".$this->name."，性别：".$this->sex."，年龄：".$this->age;
  }  
  
  /**
   * 声明一个析构方法
   */
  public function __destruct()
  {
      echo "我觉得我还可以再抢救一下，我的名字叫".$this->name;
  }
}

$Person = new Person("小明");
unset($Person); //销毁上面创建的对象$Person
```

## `__call` `__callStatic`
在对象中调用一个不可访问方法时，`__call()` 会被调用。

在静态上下文中调用一个不可访问方法时，`__callStatic()` 会被调用。
```php
class MethodTest 
{
    public function __call($name, $arguments) 
    {
        // 注意: $name 的值区分大小写
        echo "Calling object method '$name' "
             . implode(', ', $arguments). "\n";
    }

    /**  PHP 5.3.0之后版本  */
    public static function __callStatic($name, $arguments) 
    {
        // 注意: $name 的值区分大小写
        echo "Calling static method '$name' "
             . implode(', ', $arguments). "\n";
    }
}

$obj = new MethodTest;
$obj->runTest('in object context'); # Calling object method 'runTest' in object context

MethodTest::runTest('in static context');  # Calling static method 'runTest' in static context
```

