provider "aws" {
region     = "ap-south-1"
access_key = var.access_key
secret_key = var.secret_key

}
resource "aws_instance" "name" {
  ami                    = "ami-0dee22c13ea7a9a67"
  instance_type          = "t3.micro"
  key_name               = "ram"
  vpc_security_group_ids = ["sg-0493213f585412a23"]
  tags = {
    name = "lms1122"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt install python3-pip -y",
      "sudo apt install python3-venv -y",
      "python3 -m venv /home/ubuntu/venv",
      ". /home/ubuntu/venv/bin/activate",
      "git clone https://github.com/gsreddy1870/nlm2.git",
      "cd nlm2",
      "pip install django",
      "sudo apt-get install libmysqlclient-dev -y",
      "sudo apt install pkg-config -y",
      "pip install mysqlclient",
      "pip  install -r requirements.txt",
      "python /home/ubuntu/nlm2/manage.py makemgrations",
      "python /home/ubuntu/nlm2/manage.py migrate",
      "python /home/ubuntu/nlm2/manage.py runserver 0.0.0.0:8000"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("ram.pem")
      host        = self.public_ip
    }

  }

}
