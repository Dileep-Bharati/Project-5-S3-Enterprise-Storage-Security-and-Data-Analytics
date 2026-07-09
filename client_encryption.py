import boto3
from cryptography.fernet import Fernet

# Make a secret key for the mini-safe
key = Fernet.generate_key()
cipher = Fernet(key)

# The secret toy
plaintext = b"This is my super secret data!"
print(f"\n1. Original data: {plaintext.decode()}")

# Lock the toy in the safe BEFORE uploading
encrypted_data = cipher.encrypt(plaintext)
print(f"2. Encrypted gibberish going to AWS: {encrypted_data[:40]}...")

# Upload to AWS S3
s3 = boto3.client('s3', region_name='us-east-1')
s3.put_object(
    Bucket='project5-encrypted-258927109117',
    Key='client-side-test.txt',
    Body=encrypted_data
)
print("3. Uploaded safely to AWS!")
