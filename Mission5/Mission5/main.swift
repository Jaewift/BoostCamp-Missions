//
//  main.swift
//  Mission5
//
//  Created by jaegu park on 9/19/24.
//

import pydot

class Property:
    def __init__(self, name, prop_type):
        self.name = name
        self.prop_type = prop_type

class Type:
    def __init__(self, name, properties):
        self.name = name
        self.properties = properties

class File:
    def __init__(self, name, type_obj):
        self.name = name
        self.type_obj = type_obj

class Package:
    def __init__(self, name, files):
        self.name = name
        self.files = files

def create_graph(packages):
    graph = pydot.Dot(graph_type='digraph')

    system_package = pydot.Cluster('System Package', label='System Package', style='tab', color='blue')
    system_file = pydot.Cluster('System File', label='Source.file', style='tab', color='lightgrey')
    system_string = pydot.Node('String', shape='box', style='filled', color='cyan')
    system_int = pydot.Node('Int', shape='box', style='filled', color='cyan')
    system_file.add_node(system_string)
    system_file.add_node(system_int)
    system_package.add_subgraph(system_file)
    graph.add_subgraph(system_package)
    for package in packages:
      package_cluster = pydot.Cluster(package.name, label=f"{package.name} Package", style='tab', color='blue')
      for file in package.files:
          file_cluster = pydot.Cluster(file.name, label=file.name, style='tab', color='lightgrey')
          type_node = pydot.Node(file.type_obj.name, shape='box', style='filled', color='cyan')
          file_cluster.add_node(type_node)
          for prop in file.type_obj.properties:
              prop_node = pydot.Node(prop.name)
              file_cluster.add_node(prop_node)
              graph.add_edge(pydot.Edge(prop.name, prop.prop_type))
          package_cluster.add_subgraph(file_cluster)
      graph.add_subgraph(package_cluster)

    return graph.to_string()

def get_user_input():
    packages = []
    types = {"Int", "String"}
    while True:
        package_name = input("추가할 패키지명을 입력하세요(패키지명 입력을 끝내려면 'exit'을 입력하세요): ")
        if package_name.lower() == 'exit':
            break

        files = []
        while True:
            file_name = input(package_name + " Package 에 들어갈 파일명을 입력하세요(파일명 입력을 끝내려면 'exit'을 입력하세요): ")
            if file_name.lower() == 'exit':
                if files.__len__() == 0:
                    print("Package 에는 하나 이상의 파일이 들어가야 합니다. ")
                    continue;
                break

            type_name = input(file_name + "의 타입명을 입력하세요: ")
            types.add(type_name);
            properties = []
            while True:
                property_name = input(file_name + "에 들어갈 속성명을 입력하세요(속성명 입력을 끝내려면 'exit'을 입력하세요): ")
                if property_name.lower() == 'exit':
                    break
                property_type = input(property_name + " 속성의 타입을 입력하세요: ")
                if property_type not in types:
                    print("존재하지 않는 타입입니다. 속성명 부터 다시 입력해주세요");
                    continue;
                properties.append(Property(property_name, property_type))
                type_obj = Type(type_name, properties)
            files.append(File(file_name+".file", type_obj))

        packages.append(Package(package_name, files))

    return packages

inputs = get_user_input()
if inputs.__len__() == 0 :
    print("추가된 패키지가 없습니다. 프로그램을 종료합니다.")
else :
  graphviz_output = create_graph(inputs)
  print(graphviz_output)

