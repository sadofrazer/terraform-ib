################### Variables##################

variable "owner" {
    default = "frazer"
}

variable "filenames" {
  default = ["file3.txt","file4.txt","file5.txt","file6.txt"]
  type = list(string)
}

#################################################


resource "local_file" "file1" {
    filename = "files/${var.owner}-file1.txt"
    content = "Bonjour à tous, ... Je source mes données du fichier d'ID : ${data.local_file.file2.id}"
    lifecycle {
      create_before_destroy = true
    }
}


data "local_file" "file2" {
    filename = "files/file2.txt"
}


resource "local_file" "files" {
    for_each = toset(var.filenames)
    filename = "files/${var.owner}-${each.value}"
    content = "files/${var.owner}-${each.value}"
}
