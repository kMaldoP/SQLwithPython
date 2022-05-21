"""create customers

Revision ID: 297c9af78fd5
Revises: 
Create Date: 2022-05-14 09:23:23.859168

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '297c9af78fd5'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    op.execute(
        """
        CREATE TABLE customers(
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL
        );
        """
    )


def downgrade():
   op.execute(
        """
        DROP TABLE customers;
        """
    )

